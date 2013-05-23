site :lille do |site_uid|

  cluster :chirloute do |cluster_uid|
    model "Dell PowerEdge C6100"
    created_at Time.parse("2011-03-25").httpdate
    kavlan true

    8.times do |i|
      node "#{cluster_uid}-#{i+1}" do |node_uid|
       
        performance({
        :core_flops => 7593000000,
        :node_flops => 58460000000
       })

        architecture({
        :smp_size => 2,
        :smt_size => 8,
        :platform_type => "x86_64"
      })

        supported_job_types({
          :deploy       => true,
          :besteffort   => true,
          :virtual      => lookup('chirloute', node_uid, 'supported_job_types', 'virtual')
        })

        architecture({
          :smp_size       => lookup('chirloute', node_uid, 'architecture', 'smp_size'),
          :smt_size       => lookup('chirloute', node_uid, 'architecture', 'smt_size'),
          :platform_type  => lookup('chirloute', node_uid, 'architecture', 'platform_type')
        })

        processor({
          :vendor             => lookup('chirloute', node_uid, 'processor', 'vendor'),
          :model              => lookup('chirloute', node_uid, 'processor', 'model'),
          :version            => lookup('chirloute', node_uid, 'processor', 'version'),
          :clock_speed        => lookup('chirloute', node_uid, 'processor', 'clock_speed'),
          :instruction_set    => lookup('chirloute', node_uid, 'processor', 'instruction_set'),
          :other_description  => lookup('chirloute', node_uid, 'processor', 'other_description'),
          :cache_l1           => lookup('chirloute', node_uid, 'processor', 'cache_l1'),
          :cache_l1i          => lookup('chirloute', node_uid, 'processor', 'cache_l1i'),
          :cache_l1d          => lookup('chirloute', node_uid, 'processor', 'cache_l1d'),
          :cache_l2           => lookup('chirloute', node_uid, 'processor', 'cache_l2'),
          :cache_l3           => lookup('chirloute', node_uid, 'processor', 'cache_l3')
        })

        main_memory({
          :ram_size     => lookup('chirloute', node_uid, 'main_memory', 'ram_size'),
          :virtual_size => nil
        })

        operating_system({
          :name     => lookup('chirloute', node_uid, 'operating_system', 'name'),
          :release  => "Squeeze",
          :version  => lookup('chirloute', node_uid, 'operating_system', 'version'),
          :kernel   => lookup('chirloute', node_uid, 'operating_system', 'kernel')
        })

        storage_devices [{
          :interface  => 'SATA',
          :size       => lookup('chirloute', node_uid, 'block_devices', 'sda', 'size'),
          :driver     => "mptsas",
          :device     => lookup('chirloute', node_uid, 'block_devices', 'sda', 'device'),
          :model      => lookup('chirloute', node_uid, 'block_devices', 'sda', 'model'),
          :vendor     => lookup('chirloute', node_uid, 'block_devices', 'sda', 'vendor'),
          :rev        => lookup('chirloute', node_uid, 'block_devices', 'sda', 'rev'),
          :raid       => "0"
        }]

        network_adapters [{
          :interface        => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'interface'),
          :rate             => 1.G,
          :enabled          => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'enabled'),
          :management       => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'management'),
          :mountable        => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'mountable'),
          :mounted          => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'mounted'),
          :vendor           => 'Intel',
          :version          => '82576EB',
          :bridged          => false,
          :device           => "eth0",
          :network_address  => "#{node_uid}-eth0.#{site_uid}.grid5000.fr",
          :switch           => 'gw-lille',
          :driver           => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'driver'),
          :ip               => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'ip'),
          :mac              => lookup('chirloute', node_uid, 'network_interfaces', 'eth0', 'mac')
        },
        {
          :interface        => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'interface'),
          :rate             => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'rate'),
          :enabled          => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'enabled'),
          :management       => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'management'),
          :mountable        => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'mountable'),
          :mounted          => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'mounted'),
          :bridged          => true,
          :device           => "eth1",
          :vendor           => 'Intel',
          :version          => '82576EB',
          :driver           => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'driver'),
          :network_address  => "#{node_uid}.#{site_uid}.grid5000.fr",
          :ip               => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'ip'),
          :ip6              => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'ip6'),
          :switch           => 'gw-lille',
          :switch_port      => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'switch_port'),
          :mac              => lookup('chirloute', node_uid, 'network_interfaces', 'eth1', 'mac')
        },
        {
          :interface            => 'Ethernet',
          :rate                 => 1.G,
          :network_address      => "#{node_uid}-ipmi.#{site_uid}.grid5000.fr",
          :ip                   => lookup('chirloute', node_uid, 'network_interfaces', 'bmc', 'ip'),
          :mac                  => lookup('chirloute', node_uid, 'network_interfaces', 'bmc', 'mac'),
          :vendor               => 'Inventec',
          :enabled              => true,
          :mounted              => false,
          :mountable            => false,
          :management           => true,
          :switch               => 'gw-lille',
          :device               => "bmc",
          :vendor                => "Inventec",
          :version               => 1.14

        }]

        chassis({
          :serial       => lookup('chirloute', node_uid, 'chassis', 'serial_number'),
          :name         => lookup('chirloute', node_uid, 'chassis', 'product_name'),
          :manufacturer => lookup('chirloute', node_uid, 'chassis', 'manufacturer')
        })

        bios({
          :version      => lookup('chirloute', node_uid, 'bios', 'version'),
          :vendor       => lookup('chirloute', node_uid, 'bios', 'vendor'),
          :release_date => lookup('chirloute', node_uid, 'bios', 'release_date')
        })

        gpu({
          :gpu        => true,
          :gpu_count  => lookup('chirloute', node_uid, 'gpu', 'gpu_count'),
          :gpu_model => lookup('chirloute', node_uid, 'gpu', 'gpu_model'),
        })

        monitoring({
          :wattmeter  => false
        })

      end
    end
  end # cluster chirloute
end
