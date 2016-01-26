require 'resolv'

module G5K
  
  class Tree < Hash
    attr_reader :contents, :path
    def write(repository, &block)
      self[:uid] ||= ""
      @contents = {}
      @path = File.join(repository, self[:uid]+".json")
      self.each do |key, value|
        if value.is_a? Folder
          value.write(File.join(repository, self[:uid], key.to_s), &block)
          @path = File.join(repository, self[:uid], self[:uid]+".json")
        else
          @contents.merge!(key => value)
        end
      end
      if !@contents.empty? && !@contents[:uid].empty?
        yield self
      end
    end
    
    def valid?
      true
      # we could do sthg like: Object.const_get(type.class.name).new(hash_values).valid?
    end
  end
  class Folder < Array
    attr_reader :path
    def write(repository, &block)
      @path = repository
      self.each do |v| 
        v.write(repository, &block)
      end
      yield self
    end
    def valid?
      true
    end
  end
  class Link < Struct.new(:uid, :refer_to)
    attr_reader :from, :path
  
    def write(repository)
      @from, @path = [refer_to, File.join(repository, "#{uid}.json")]
      yield self
    end
    def valid?
      true
    end
  end

  class ReferenceGenerator  
    attr_reader :data
    attr_reader :config
    attr_reader :input
  
    def method_missing(method, *args)
      @context.recursive_merge!(method.to_sym => args.first)
    end

    # Remotly execute commands, and retrieve stdout, stderr, exit code and exit signal.
    def ssh_exec!(ssh, command)
      stdout_data = ""
      stderr_data = ""
      exit_code = nil
      exit_signal = nil
      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            abort "FAILED: couldn't execute command (ssh.channel.exec)"
          end
          channel.on_data do |ch,data|
            stdout_data+=data
          end
          
          channel.on_extended_data do |ch,type,data|
            stderr_data+=data
          end
          
          channel.on_request("exit-status") do |ch,data|
            exit_code = data.read_long
          end
          
          channel.on_request("exit-signal") do |ch, data|
            exit_signal = data.read_long
          end
        end
      end
      ssh.loop
      [stdout_data, stderr_data, exit_code, exit_signal]
    end  
  
    # Get the IP address corresponding to the host fqdn throught ssh channel
    def dns_lookup_through_ssh(ssh,fqdn)
      results = ssh_exec! ssh, "host #{fqdn}"
      if results[2] == 0
        results[0].split(" ").reverse[0]
      else
        fail "Failed to get ip address of '#{fqdn}' : #{results[1]}"
      end
    end
  
    def dns_lookup(network_address)
      Resolv.getaddress(network_address)
    end
  
    # Lookup a key in one of the configuration files passed to the generator
    #
    # Usage:
    #   lookup('nancy', 'nodes', 'paramount-1', 'property_name')
    # or
    #   lookup('nancy', 'nodes') { |result| result['paramount-1']['property_name'] }
    # or
    #   lookup('nancy') { |result| result['nodes']['paramount-1']['property_name'] }
    # 
    # assuming you passed a <tt>nancy.yaml</tt> file to the generator
    #
    def lookup(filename, *keys, &block)
      if config.has_key?(filename)
        result = config[filename]
        if !keys.empty?
          while !keys.empty? do
            result = result[keys.shift]
            break if result.nil?
          end
        end  
        if block
          block.call(result) 
        else
          result
        end
      else
        raise ArgumentError, "Cannot fetch the values for '#{keys.inspect}' in the input file '#{filename}'. The config files you gave to me are: '#{config.keys.inspect}'."
      end
    end

    # Build portname from snmp_naming_pattern
    # Example: '3 2 GigabitEthernet%LINECARD%/%PORT%' -> 'GigabitEthernet3/2'
    def get_portname(lc_num,port_num,pattern)
      return pattern.sub("%LINECARD%",lc_num.to_s).sub("%PORT%",port_num.to_s)
    end

    # Load information from network description yaml files
    def get_net_equipment(site)
      if $net_equipment.nil?
        $net_equipment={}
      end
      if $net_equipment[site].nil?
        $net_equipment[site]={}
        Pathname.glob("generators/input/sites/#{site}/net-links/*.yaml").map  {  |i| i.basename.to_s.sub!(".yaml","") }.each do |equipment_name|
          netlinks = File.open("generators/input/sites/#{site}/net-links/#{equipment_name}.yaml")
          $net_equipment[site][equipment_name] = YAML::load_stream( netlinks )
        end
      end
      return $net_equipment[site]
    end

    # Parse network equipment description and return switch name connected to given node
    #  In the network description, if the node interface is given (using "port" attribute),
    #  the interface parameter must be used.
    def net_switch_lookup(site, cluster, node, interface='')
      get_net_equipment(site).keys.each do |equipment_name|
        get_net_equipment(site)[equipment_name][0][equipment_name]["linecards"].each do |(lc_num,lc_content)|
          lc_content["ports"].each do |(port_num,port_content)|
            if port_content.is_a?(Hash)
              netdesc_rport = port_content["port"] || lc_content["port"] || ""
              if port_content["uid"] == node and netdesc_rport == interface
                return equipment_name
              end
            elsif port_content
              netdesc_rport = lc_content["port"] || ""
              if port_content == node and netdesc_rport == interface
                return equipment_name
              end
            end
          end
        end
      end
      return nil
    end

    # Parse network equipment description and return switch port connected to given node
    #  In the network description, if the node interface is given (using "port" attribute),
    #  the interface parameter must be used.
    def net_port_lookup(site, cluster, node, interface='')
      get_net_equipment(site).keys.each do |equipment_name|
        get_net_equipment(site)[equipment_name][0][equipment_name]["linecards"].each do |(lc_num,lc_content)|
          lc_content["ports"].each do |(port_num,port_content)|
            if port_content.is_a?(Hash)
              netdesc_rport = port_content["port"] || lc_content["port"] || ""
              if port_content["uid"] == node and netdesc_rport == interface
                return get_portname(lc_num,port_num,lc_content["snmp_pattern"])
              end
            elsif port_content
              netdesc_rport = lc_content["port"] || ""
              if port_content == node and netdesc_rport == interface
                return get_portname(lc_num,port_num,lc_content["snmp_pattern"])
              end
            end
          end
        end
      end
      return nil
    end

    # This method is used exclusivly for environments. Example:
    # environment 'squeeze-x64-xen-0.8' do
    #  available_on %w{grenoble lille lyon nancy rennes sophia}
    # end    
    def available_on(sites_uid)
      env_uid = @context[:uid]
      old_context = @context 
      @context = @data
      sites_uid.each{|site_uid|
        site site_uid.to_sym, {:discard_content => true} do
          environment "#{env_uid}", :refer_to => "grid5000/environments/#{env_uid}"    
        end
      }
      @context = old_context
    end
    # This doesn't work with Ruby < 1.8.7. Replaced by a call to build_context (see below).
    #
    # %w{site cluster environment node service}.each do |method|
    #   define_method(method) do |uid, *options, &block|
    #     key = method.pluralize.to_sym
    #     uid = uid.to_s
    #     options = options.first || Hash.new
    #     old_context = @context
    #     @context[key] ||= G5K::Folder.new
    #     if options.has_key? :refer_to
    #       @context[key] << G5K::Link.new(uid, options[:refer_to])
    #     else    
    #       # if the same object already exists, we return it for completion/modification
    #       if (same_trees = @context[key].select{|tree| tree[:uid] == uid}).size > 0
    #         @context = same_trees.first
    #       else
    #         @context[key] << G5K::Tree.new.replace({:uid => uid, :type => method})
    #         @context = @context[key].last
    #       end
    #       block.call(uid) if block
    #     end
    #     @context = old_context
    #   end
    # end
  
    def site(uid, *options, &block)
      build_context(:sites, uid, *options, &block)
    end
    def cluster(uid, *options, &block)
      build_context(:clusters, uid, *options, &block)
    end
    def server(uid, *options, &block)
      build_context(:servers, uid, *options, &block)
    end
    def environment(uid, *options, &block)
      build_context(:environments, uid, *options, &block)
    end
    def network_equipment(uid, *options, &block)
      build_context(:network_equipments, uid, *options, &block)
    end
    def node(uid, *options, &block)
      build_context(:nodes, uid, *options, &block)
    end
    def pdu(uid, *options, &block)
      build_context(:pdus, uid, *options, &block)
    end
    def service(uid, *options, &block)
      build_context(:services, uid, *options, &block)
    end
    def network_equipment(uid, *options, &block)
      build_context(:network_equipments, uid, *options, &block)
    end
    def build_context(key, uid, *options, &block)
      type = key.to_s.chop
      uid = uid.to_s
      options = options.first || Hash.new
      old_context = @context
      @context[key] ||= G5K::Folder.new
      if options.has_key? :refer_to
        @context[key] << G5K::Link.new(uid, options[:refer_to])
      else    
        # if the same object already exists, we return it for completion/modification
        if (same_trees = @context[key].select{|tree| tree[:uid] == uid}).size > 0
          @context = same_trees.first
        else
          @context[key] << G5K::Tree.new.replace({:uid => uid, :type => type}.merge((options[:discard_content]) ? {:discard_content => true} : {}))
          @context = @context[key].last
        end
        block.call(uid) if block
      end
      @context = old_context
    end
  
    # Initializes a new generator that will generate data files in a hierachical way. 
    # The root of the tree will be named with the value of <tt>data_description[:uid]</tt>.
    def initialize(data_description = {:uid => ""}, options = {:input => {}, :config => {}})
      @input = options[:input]
      raise(ArgumentError, "INPUT cannot be null or empty.") if input.nil? || input.empty?
      @config = options[:config] || {}
      @data = G5K::Tree.new.replace(data_description)
      @context = @data
    end
  
    def generate
      input.each do |filename, content|
        eval(content)
      end
      @data
    end
 
    def measurement_point_name(measure_point,site)
      port=measure_point[:port] || measure_point[:measure] || 0
      measure_point_name="#{port}.#{measure_point[:uid]}.#{site[:uid]}.grid5000.fr"
      measure_point_name
    end
    
    def count_measurement_points(pdu_info,site_pdu_outlets,site)
      pdu_info.each do |measure_point|
        measure_point_name=measurement_point_name(measure_point,site)
        site_pdu_outlets[measure_point_name]=0 unless site_pdu_outlets.has_key?(measure_point_name)
        site_pdu_outlets[measure_point_name]+=1
      end
    end
    
    # compute the annotation for the ["monitoring"]["wattmeter"] section from
    # A pdu_info array representing all the pdus to take into account for a view of power consumption
    # A site_pdus array with information about whether a given pdu has per_outlets measurements
    # a site_pdu_outlets array with information about the number of nodes connected ot a given pdu outlet
    def monitoring_wattmeter_annotation(pdu_info, site_pdus, site_pdu_outlets,site)
      per_outlet=true
      pdu_info.each do |a_pdu_info|
        measure_name=measurement_point_name(a_pdu_info,site)
        if site_pdu_outlets[measure_name] && site_pdu_outlets[measure_name] > 1
          per_outlet=false #at least two nodes are pointing to the same measurement point 
        else
          per_outlet=per_outlet && site_pdus[a_pdu_info[:uid]] rescue nil
        end
      end
      if per_outlet.nil?
        node_monitoring_wattmeter=:false
      elsif pdu_info.size > 1
        if per_outlet
          node_monitoring_wattmeter=:multiple
        else
          node_monitoring_wattmeter=:multiple_shared
        end
      else
        if per_outlet
          node_monitoring_wattmeter=:true
        else
          node_monitoring_wattmeter=:shared
        end
      end
      node_monitoring_wattmeter
    end

    # Attempts to add information to @data to help users
    def annotate
      @data[:sites].each do |site|
        site_pdus={}
        site_pdu_outlets={}
        metric_nodes={}
        node_monitoring_wattmeter={}
        if site[:clusters].nil?
          return
        end
        unless site[:pdus].nil?
          site[:pdus].each do |pdu|
            site_pdus[pdu[:uid]]=pdu[:sensors][0][:power][:per_outlets] rescue nil
            pp pdu if site_pdus[pdu[:uid]].nil?
          end
          site[:clusters].each do |cluster|
            cluster[:nodes].each do |node|
              pdu_info=node[:sensors][:power][:via][:pdu] rescue nil
              unless pdu_info.nil?
                if pdu_info.size > 0 
                  if pdu_info.first.is_a?(Array)
                    pdu_info.each do |a_pdu_info|
                      count_measurement_points(a_pdu_info,site_pdu_outlets,site)
                    end
                  else
                    count_measurement_points(pdu_info,site_pdu_outlets,site)
                  end
                end
              end
            end
          end
          site[:clusters].each do |cluster|
            cluster[:nodes].each do |node|
              node_monitoring_wattmeter[node[:uid]]=:false
              pdu_info=node[:sensors][:power][:via][:pdu] rescue nil
              unless pdu_info.nil?
                # pdu_info is either
                # [{:uid=>"parapluie-pdu-4", :port=>2}] in the simple case
                # [{:uid=>"graphene-pdu9", :port=>23}, {:uid=>"graphene-pdu9", :port=>24}] when plugged to 2 outlets
                # [[{:uid=>"adonis-pdu-1", :port=>"outlet-11"},{:uid=>"adonis-pdu-1", :port=>"outlet-12"}],
                #  [{:measure=>"block-1", :uid=>"adonis-pdu-1"}]]
                raise ArgumentError, "Node #{node[:uid]}[:sensors][:power][:via][:pdu] should be an Array" unless pdu_info.is_a?(Array)
                if pdu_info.size > 0 
                  if pdu_info.first.is_a?(Array)
                    # multiple measurement options : advertise the best
                    priority={
                      :true => 5,
                      :multiple => 4,
                      :shared => 3,
                      :multiple_shared => 2,
                      :false => 1,
                    }
                    node_monitoring_wattmeter[node[:uid]]=:false
                    pdu_info.each do |a_pdu_info|
                      local_monitoring_wattmeter=monitoring_wattmeter_annotation(a_pdu_info,site_pdus,site_pdu_outlets,site)
                      if priority[local_monitoring_wattmeter] > priority[node_monitoring_wattmeter[node[:uid]]]
                        node_monitoring_wattmeter[node[:uid]]=local_monitoring_wattmeter
                      end
                    end
                  else 
                    node_monitoring_wattmeter[node[:uid]]=monitoring_wattmeter_annotation(pdu_info,site_pdus,site_pdu_outlets,site)
                  end
                end               
              else
                ipmi_info=node[:sensors][:power][:via][:ipmi] rescue nil
                unless ipmi_info.nil?
                  node_monitoring_wattmeter[node[:uid]]=:outofband
                end
              end
            end
          end
        end
        site[:clusters].each do |cluster|
          cluster[:nodes].each do |node|
            node_monitoring_wattmeter[node[:uid]]=:false unless node_monitoring_wattmeter.has_key?(node[:uid])
            if node.has_key?(:monitoring)
              if node[:monitoring].has_key?(:wattmeter)
                if node[:monitoring][:wattmeter] != node_monitoring_wattmeter[node[:uid]]
                  puts "#{node[:uid]}[:monitoring][:wattmeter] override calculated information with information found in input. Calculated it should be #{node_monitoring_wattmeter[node[:uid]]}, keeping #{node[:monitoring][:wattmeter]}"
                end
              else #create wattmeter entry
                node[:monitoring][:wattmeter]= node_monitoring_wattmeter[node[:uid]]
              end
            else #create monitoring entry
              node[:monitoring]={:wattmeter => node_monitoring_wattmeter[node[:uid]]}
            end
            #puts "#{node[:uid]}[:monitoring][:wattmeter] = #{node[:monitoring][:wattmeter]}"
          end
        end
      end
    end

    def write(repository, options = {:simulate => false})
      things_to_create = []
      @data.write("/") do |thing_to_create|
        things_to_create << thing_to_create if thing_to_create.valid?
      end
      groups = things_to_create.group_by{|thing| thing.class}
      groups.has_key?(G5K::Folder) and groups[G5K::Folder].each do |folder|
        full_path = File.join(repository, folder.path)
        unless File.exists?(full_path)
          puts "Directory to be written = \t#{full_path}"
          FileUtils.mkdir_p(full_path) unless options[:simulate]
        end
      end
      groups.has_key?(G5K::Tree) and groups[G5K::Tree].each do |file|
        full_path = File.join(repository, file.path)
        new_content = JSON.pretty_generate(file.contents)
        existing_content = File.exists?(full_path) ? File.open(full_path, "r").read : ""
        if new_content.hash != existing_content.hash
          unless file.has_key? :discard_content and file[:discard_content]
            puts "File to be written      = \t#{full_path}"
            File.open(full_path, "w+"){ |f| f << new_content  } unless options[:simulate]
          end
        end
      end
      groups.has_key?(G5K::Link) and groups[G5K::Link].each do |link|      
        FileUtils.cd(repository) do |dir|
          to = File.join(".", link.path)
          from = File.join([".."]*(to.count(File::SEPARATOR)-1), "#{link.from}.json")
          unless File.exists?(to)
            puts "Symbolic link to be written = \t#{to} -> #{from}"
            FileUtils.ln_s(from, to, :force => true) unless options[:simulate]
          end
        end
      end  
    end
  
  end
end
