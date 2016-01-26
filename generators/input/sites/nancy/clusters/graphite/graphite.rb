site :nancy do |site_uid|

  cluster :graphite do |cluster_uid|
    model "Dell R720"
    created_at Time.parse("2013-12-5").httpdate
    kavlan true
    production true

    4.times do |i|
      node "#{cluster_uid}-#{i+1}" do |node_uid|

        performance({
          :core_flops => 13.17.G,
          :node_flops => 187.90.G
        })

        supported_job_types({
          :deploy       => true,
          :besteffort   => true,
          :max_walltime => 0,
          :virtual      => lookup(node_uid, node_uid, 'supported_job_types', 'virtual'),
          :queues       => ['default', 'admin']
        })

        architecture({
          :smp_size       => lookup(node_uid, node_uid, 'architecture', 'smp_size'),
          :smt_size       => lookup(node_uid, node_uid, 'architecture', 'smt_size'),
          :platform_type  => lookup(node_uid, node_uid, 'architecture', 'platform_type')
        })

        processor({
          :vendor             => lookup(node_uid, node_uid, 'processor', 'vendor'),
          :model              => lookup(node_uid, node_uid, 'processor', 'model'),
          :version            => lookup(node_uid, node_uid, 'processor', 'version'),
          :clock_speed        => lookup(node_uid, node_uid, 'processor', 'clock_speed'),
          :instruction_set    => lookup(node_uid, node_uid, 'processor', 'instruction_set'),
          :other_description  => lookup(node_uid, node_uid, 'processor', 'other_description'),
          :cache_l1           => lookup(node_uid, node_uid, 'processor', 'cache_l1'),
          :cache_l1i          => lookup(node_uid, node_uid, 'processor', 'cache_l1i'),
          :cache_l1d          => lookup(node_uid, node_uid, 'processor', 'cache_l1d'),
          :cache_l2           => lookup(node_uid, node_uid, 'processor', 'cache_l2'),
          :cache_l3           => lookup(node_uid, node_uid, 'processor', 'cache_l3')
        })

        main_memory({
          :ram_size     => lookup(node_uid, node_uid, 'main_memory', 'ram_size'),
          :virtual_size => nil
        })

        operating_system({
          :name     => "debian",
          :release  => "Jessie",
          :version  => "8.2",
          :kernel   => "3.16.0-4-amd64"
        })

        storage_devices [{
          :interface  => 'SATA II',
          :size       => lookup(node_uid, node_uid, 'block_devices', 'sda', 'size'),
          :driver     => "megaraid_sas",
          :device     => lookup(node_uid, node_uid, 'block_devices', 'sda', 'device'),
          :model      => lookup(node_uid, node_uid, 'block_devices', 'sda', 'model'),
          :vendor     => lookup(node_uid, node_uid, 'block_devices', 'sda', 'vendor'),
          :rev        => lookup(node_uid, node_uid, 'block_devices', 'sda', 'rev'),
          :storage    => 'SSD'
        },
        {
          :interface  => 'SATA II',
          :size       => lookup(node_uid, node_uid, 'block_devices', 'sdb', 'size'),
          :driver     => "megaraid_sas",
          :device     => lookup(node_uid, node_uid, 'block_devices', 'sdb', 'device'),
          :model      => lookup(node_uid, node_uid, 'block_devices', 'sdb', 'model'),
          :vendor     => lookup(node_uid, node_uid, 'block_devices', 'sdb', 'vendor'),
          :rev        => lookup(node_uid, node_uid, 'block_devices', 'sdb', 'rev'),
          :storage    => 'SSD'
        }]

        network_adapters [{
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'interface'),
          :rate             => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'rate'),
          :enabled          => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'enabled'),
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'management'),
          :mountable        => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'mountable'),
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'mounted'),
          :bridged          => true,
          :device           => "eth0",
          :vendor           => "intel",
          :version          => "82599EB",
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'driver'),
          :network_address  => "#{node_uid}.#{site_uid}.grid5000.fr",
          :ip               => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'ip'),
          :ip6              => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'ip6'),
          :switch           => net_switch_lookup('nancy','graphite', node_uid),
          :switch_port      => net_port_lookup('nancy','graphite', node_uid),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'mac')
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'interface'),
          :rate             => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'rate'),
          :enabled          => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'enabled'),
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'management'),
          :mountable        => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'mountable'),
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'mounted'),
          :bridged          => false,
          :device           => "eth1",
          :vendor           => "intel",
          :version          => "82599EB",
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'mac')
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'interface'),
          :rate             => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'rate'),
          :enabled          => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'enabled'),
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'management'),
          :mountable        => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'mountable'),
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'mounted'),
          :bridged          => false,
          :device           => "eth2",
          :vendor           => "intel",
          :version          => "I350",
          :switch           => net_switch_lookup('nancy','graphite', node_uid, 'eth2'),
          :switch_port      => net_port_lookup('nancy','graphite', node_uid, 'eth2'),
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'mac')
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'interface'),
          :rate             => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'rate'),
          :enabled          => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'enabled'),
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'management'),
          :mountable        => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'mountable'),
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'mounted'),
          :bridged          => false,
          :device           => "eth3",
          :vendor           => "intel",
          :version          => "I350",
          :switch           => net_switch_lookup('nancy','graphite', node_uid, 'eth3'),
          :switch_port      => net_port_lookup('nancy','graphite', node_uid, 'eth3'),
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'mac')
        },
        {
          :interface => 'Ethernet',
          :rate => 100.M,
          :enabled => true,
          :mounted => false,
          :mountable => false,
          :management => true,
          :vendor => "DELL",
          :version => "IDRAC7",
          :device => "bmc",
          :ip => lookup(node_uid, node_uid, 'network_interfaces', 'bmc', 'ip'),
          :mac => lookup(node_uid, node_uid, 'network_interfaces', 'bmc', 'mac'),
          :network_address => "#{node_uid}-bmc.#{site_uid}.grid5000.fr",
          :switch => lookup('graphite_manual', node_uid, 'network_interfaces', 'bmc', 'switch_name'),
          :switch_port => lookup('graphite_manual', node_uid, 'network_interfaces', 'bmc', 'switch_port')
        }]

        chassis({
          :serial       => lookup(node_uid, node_uid, 'chassis', 'serial_number'),
          :name         => lookup(node_uid, node_uid, 'chassis', 'product_name'),
          :manufacturer => lookup(node_uid, node_uid, 'chassis', 'manufacturer')
        })

        bios({
          :version      => lookup(node_uid, node_uid, 'bios', 'version'),
          :vendor       => lookup(node_uid, node_uid, 'bios', 'vendor'),
          :release_date => lookup(node_uid, node_uid, 'bios', 'release_date')
        })

        mic({
          :mic        => true,
          :mic_count  => lookup('graphite_manual', node_uid, 'mic', 'mic_count'),
          :mic_model => lookup('graphite_manual', node_uid, 'mic', 'mic_model'),
        })

        gpu({
          :gpu  => false
        })

       sensors({
              :power => {
                :available => true,
                :via => {
                  :api => { :metric => 'power' },
                  :pdu => [ {
                    :uid  => lookup('graphite_manual', node_uid, 'pdu1', 'pdu_name'),
                    :port => lookup('graphite_manual', node_uid, 'pdu1', 'pdu_position'),
                  },
 		          {
                    :uid  => lookup('graphite_manual', node_uid, 'pdu2', 'pdu_name'),
                    :port => lookup('graphite_manual', node_uid, 'pdu2', 'pdu_position'),
                  } ]
                }
              }
            })

      end
    end
  end # cluster graphite
end
