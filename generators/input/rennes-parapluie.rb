site :rennes do |site_uid|
  
  cluster :parapluie do |cluster_uid|
     model "HP ProLiant DL165 G7"
     created_at Time.parse("2010-11-02").httpdate

     40.times do |i|
       node "#{cluster_uid}-#{i+1}" do |node_uid|
         supported_job_types({:deploy => true, :besteffort => true, :virtual => "amd-v"})
         architecture({
           :smp_size       => 2, 
           :smt_size       => 24,
           :platform_type  => "amd64"
           })
         processor({
           :vendor             => "AMD",
           :model              => "AMD Opteron",
           :version            => "6164 HE",
           :clock_speed        => 1.7.G,
           :instruction_set    => "",
           :other_description  => "",
           :cache_l1           => nil,
           :cache_l1i          => nil,
           :cache_l1d          => nil,
           :cache_l2           => nil
         })
         main_memory({
           :ram_size     => 48.GiB,
           :virtual_size => nil
         })
         operating_system({
           :name     => "Debian",
           :release  => "5.0",
           :version  => nil,
           :kernel   => "2.6.26"
         })
         storage_devices [{
           :interface  => 'SATA',
           :size       => 244198584.KiB,
           :driver     => "ahci",
           :device     => "sda",
           :model      => lookup('rennes-parapluie', node_uid, 'block_devices', 'sda', 'model'),
           :rev        => lookup('rennes-parapluie', node_uid, 'block_devices', 'sda', 'rev'),
         }]
         network_adapters [{
           :interface        => 'Ethernet',
           :rate             => 1.G,
           :enabled          => true,
           :management       => true,
           :mountable        => false,
           :mounted          => false,
           :device           => "bmc",
           :network_address  => "#{node_uid}-bmc.#{site_uid}.grid5000.fr",
           :ip               => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'bmc', 'ip'),
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'bmc', 'mac')
         },
         {
           :interface        => 'Ethernet',
           :rate             => 1.G,
           :enabled          => false,
           :device           => "eth0",
           :driver           => "igb",
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'eth0', 'mac')
         },
         {
           :interface        => 'Ethernet',
           :rate             => 1.G,
           :enabled          => true,
           :mountable        => true,
           :mounted          => true,
           :device           => "eth1",
           :driver           => "igb",
           :network_address  => "#{node_uid}.#{site_uid}.grid5000.fr",
           :ip               => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'eth1', 'ip'),
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'eth1', 'mac')
         },
         {
           :interface        => 'Ethernet',
           :rate             => 1.G,
           :enabled          => false,
           :device           => "eth2",
           :driver           => "igb",
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'eth2', 'mac')
         },
         {
           :interface        => 'Ethernet',
           :rate             => 1.G,
           :enabled          => false,
           :device           => "eth3",
           :driver           => "igb",
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'eth3', 'mac')
         },
         {
           :interface        => 'Infiniband',
           :rate             => 10.G,
           :enabled          => true,
           :mountable        => true,
           :mounted          => true,
           :device           => "ib0",
           :driver           => "mlx4_core",
           :vendor           => "Mellanox",
           :version          => "MT25418",
           :network_address  => "#{node_uid}-ib0.#{site_uid}.grid5000.fr",
           :ip               => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'ib0', 'ip'),
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'ib0', 'guid')
         },
         {
           :interface        => 'Infiniband',
           :rate             => 10.G,
           :enabled          => false,
           :device           => "ib1",
           :driver           => "mlx4_core",
           :vendor           => "Mellanox",
           :version          => "MT25418",
           :mac              => lookup('rennes-parapluie', node_uid, 'network_interfaces', 'ib1', 'guid')
         }]
         bios({
           :version      => lookup('rennes-parapluie', node_uid, 'bios', 'version'),
           :vendor       => lookup('rennes-parapluie', node_uid, 'bios', 'vendor'),
           :release_date => lookup('rennes-parapluie', node_uid, 'bios', 'release_date')
         })
         chassis({:serial_number => lookup('rennes-parapluie', node_uid, 'chassis', 'serial_number')})
       end
     end

   end
  
end