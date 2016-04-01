site :lille do |site_uid|
  name "Lille"
  location "Lille, France"
  web "http://www.grid5000.fr/mediawiki/index.php/Lille:Home"
  description "Grid5000 Lille site"
  latitude 50.6500
  longitude 3.0833
  email_contact "support-staff@lists.grid5000.fr"
  sys_admin_contact "support-staff@lists.grid5000.fr"
  security_contact "support-staff@lists.grid5000.fr"
  user_support_contact "support-staff@lists.grid5000.fr"
  compilation_server false
  kavlan_ip_range "10.8.0.0/14"
  virt_ip_range "10.136.0.0/14"
  storage5k false
  production true

  g5ksubnet({
    :network => '10.136.0.0/14',
    :gateway => '10.139.255.254'
  })

  kavlans({
    'default' => {
      :network => '172.16.32.0/20',
      :gateway => '172.16.47.254'
    },
    '1' => {
      :network => '192.168.192.0/20',
      :gateway => '172.16.47.131'
    },
    '2' => {
      :network => '192.168.208.0/20',
      :gateway => '172.16.47.132'
    },
    '3' => {
      :network => '192.168.224.0/20',
      :gateway => '172.16.47.133'
    },
    '4' => {
      :network => '10.8.0.0/18',
      :gateway => '10.8.63.254'
    },
    '5' => {
      :network => '10.8.64.0/18',
      :gateway => '10.8.127.254'
    },
    '6' => {
      :network => '10.8.128.0/18',
      :gateway => '10.8.191.254'
    },
    '7' => {
      :network => '10.8.192.0/18',
      :gateway => '10.8.255.254'
    },
    '8' => {
      :network => '10.9.0.0/18',
      :gateway => '10.9.63.254'
    },
    '9' => {
      :network => '10.9.64.0/18',
      :gateway => '10.9.127.254'
    },
    '12' => {
      :network => '10.11.192.0/18',
      :gateway => '10.11.255.254'
    },
  })

end
