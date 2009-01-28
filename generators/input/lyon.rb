site :lyon do
  name "Lyon"
  location "Lyon, France"
  web
  description ""
  latitude
  longitude
  email_contact
  sys_admin_contact
  security_contact
  user_support_contact
  %w{sid-x64-base-1.0}.each{|env_uid| environment env_uid, :refer_to => "grid5000/environments/#{env_uid}"}
  
  cluster :capricorne do
    model "IBM eServer 325"
    date_of_arrival Time.parse("2004-12-01 12:00 GMT").to_i
    misc "bios: 1.36 / bcm: 1.20.9 / bmc: 1.46"
    56.times do |i|
      node "capricorne-#{i+1}" do
        architecture({
          :smp_size => 2, 
          :smt_size => 2,
          :platform_type => "x86_64"
          })
        processor({
          :vendor => "AMD",
          :model => "AMD Opteron",
          :version => "246",
          :clock_speed => 2.giga,
          :instruction_set => "",
          :other_description => "",
          :cache_l1 => nil,
          :cache_l1i => nil,
          :cache_l1d => nil,
          :cache_l2 => 1.MB
        })
        main_memory({
          :ram_size => 2.GB(true), # bytes
          :virtual_size => nil
        })
        operating_system({
          :name => nil,
          :release => nil,
          :version => nil
        })
        storage_devices [
          {:interface => 'IDE', :size => 80.GB(false), :driver => "amd74xx"}
          ]
        network_adapters [
          {:interface => 'Myri-2000', :rate => 2.giga, :vendor => 'Myrinet', :version => "M3F-PCIXF-2", :enabled => true},
          {:interface => 'Ethernet', :rate => 1.giga, :enabled => true, :driver => "tg3"}
          ]        
      end
    end    
  end # cluster capricorne
  
  cluster :sagittaire do
    model "Sun Fire V20z"
    date_of_arrival Time.parse("2006-07-01 12:00 GMT").to_i
    79.times do |i|
      node "sagittaire-#{i+1}" do
        architecture({
          :smp_size => 2, 
          :smt_size => 2,
          :platform_type => "x86_64"
          })
        processor({
          :vendor => "AMD",
          :model => "AMD Opteron",
          :version => "250",
          :clock_speed => 2.4.giga,
          :instruction_set => "",
          :other_description => "",
          :cache_l1 => nil,
          :cache_l1i => nil,
          :cache_l1d => nil,
          :cache_l2 => 1.MB
        })
        main_memory({
          :ram_size => 2.GB(true), # bytes
          :virtual_size => nil
        })
        operating_system({
          :name => nil,
          :release => nil,
          :version => nil
        })
        storage_devices [
          {:interface => 'SCSI', :size => 73.GB(false), :driver => "mptspi"}
          ]
        network_adapters [
          {:interface => 'Ethernet', :rate => 1.giga, :enabled => true, :driver => "tg3"}
          ]        
      end
    end    
  end # cluster sagittaire
  
end