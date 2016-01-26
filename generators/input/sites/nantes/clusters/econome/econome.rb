site :nantes do |site_uid|

  cluster :econome do |cluster_uid|
    model "Dell PowerEdge C6220"
    created_at Time.parse("2014-04-16").httpdate
    kavlan true
    production true

    22.times do |i|
      node "#{cluster_uid}-#{i+1}" do |node_uid|

        performance({
          :core_flops => 14040000000,
          :node_flops => 207400000000,
        })

        supported_job_types({
          :deploy       => true,
          :besteffort   => true,
          :virtual      => lookup(node_uid, node_uid, 'supported_job_types', 'virtual')
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
          :release  => "jessie",
          :version  => "8",
          :kernel   => "3.16.0-4-amd64"
        })

        storage_devices [{
          :interface => 'SATA',
          :driver    => "ahci",
          :device    => lookup(node_uid, node_uid, 'block_devices' ,'sda', 'device'),
          :size      => lookup(node_uid, node_uid, 'block_devices' ,'sda', 'size'),
          :model     => lookup(node_uid, node_uid, 'block_devices' ,'sda', 'model'),
          :rev       => lookup(node_uid, node_uid, 'block_devices', 'sda', 'rev'),
          :storage   => 'HDD'
        }]

        network_adapters [        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'interface'),
          :network_address  => "#{node_uid}.#{site_uid}.grid5000.fr",
          :ip               => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'ip'),
          :rate             => 10.G,
          :device           => "eth0",
          :enabled          => true,
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'management'),
          :mountable        => true,
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'mounted'),
          :bridged          => true,
          :vendor           => "Intel",
          :version          => '82599EB 10-Gigabit SFI/SFP+ Network Connection',
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth0', 'mac'),
          :switch_port      => net_port_lookup('nantes', 'econome', node_uid, 'eth0'),
          :switch           => net_switch_lookup('nantes', 'econome', node_uid, 'eth0'),
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'interface'),
          :rate             => 10.G,
          :rate             => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'rate'),
          :enabled          => false,
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'management'),
          :mountable        => false,
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'mounted'),
          :bridged          => false,
          :device           => "eth1",
          :vendor           => "Intel",
          :version          => '82599EB 10-Gigabit SFI/SFP+ Network Connection',
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth1', 'mac')
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'interface'),
          :rate             => 1.G,
          :enabled          => false,
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'management'),
          :mountable        => false,
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'mounted'),
          :bridged          => false,
          :device           => "eth2",
          :vendor           => "Intel",
          :version          => "Intel Corporation",
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth2', 'mac'),
        },
        {
          :interface        => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'interface'),
          :rate             => 1.G,
          :enabled          => false,
          :management       => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'management'),
          :mountable        => false,
          :mounted          => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'mounted'),
          :bridged          => false,
          :device           => "eth3",
          :vendor           => "Intel",
          :version          => "Intel Corporation",
          :driver           => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'driver'),
          :mac              => lookup(node_uid, node_uid, 'network_interfaces', 'eth3', 'mac')
        },
        {
          :interface            => 'Ethernet',
          :network_address  => "#{node_uid}-bmc.#{site_uid}.grid5000.fr",
          :rate                 => 1.G,
          :network_address      => "#{node_uid}-bmc.#{site_uid}.grid5000.fr",
          :ip                   => lookup(node_uid, node_uid, 'network_interfaces', 'bmc', 'ip'),
          :mac                  => lookup(node_uid, node_uid, 'network_interfaces', 'bmc', 'mac'),
          :enabled              => true,
          :mounted              => false,
          :mountable            => false,
          :management           => true,
          :device               => "bmc",
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

        gpu({
          :gpu => false
        })

        sensors({
          :power => {
            :available => false,
          }
        })

      end
    end
  end
end

