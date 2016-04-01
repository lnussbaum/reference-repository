site :lyon do |site_uid|
  name "Lyon"
  location "Lyon, France"
  web "https://www.grid5000.fr/mediawiki/index.php/Lyon:Home"
  description "Lyon Grid'5000 Site"
  latitude 45.7667
  longitude 4.8333
  email_contact "support-staff@lists.grid5000.fr"
  sys_admin_contact "support-staff@lists.grid5000.fr"
  security_contact "support-staff@lists.grid5000.fr"
  user_support_contact "support-staff@lists.grid5000.fr"
  compilation_server false
  kavlan_ip_range "10.12.0.0/14"
  virt_ip_range "10.140.0.0/14"
  storage5k true
  production true

  g5ksubnet({
    :network => '10.140.0.0/14',
    :gateway => '10.143.255.254'
  })

  kavlans({
    'default' => {
      :network => '172.16.48.0/20',
      :gateway => '172.16.63.254'
    },
    '1' => {
      :network => '192.168.192.0/20',
      :gateway => '172.16.63.122'
    },
    '2' => {
      :network => '192.168.208.0/20',
      :gateway => '172.16.63.123'
    },
    '3' => {
      :network => '192.168.224.0/20',
      :gateway => '172.16.63.124'
    },
    '4' => {
      :network => '10.12.0.0/18',
      :gateway => '10.12.63.254'
    },
    '5' => {
      :network => '10.12.64.0/18',
      :gateway => '10.12.127.254'
    },
    '6' => {
      :network => '10.12.128.0/18',
      :gateway => '10.12.191.254'
    },
    '7' => {
      :network => '10.12.192.0/18',
      :gateway => '10.12.255.254'
    },
    '8' => {
      :network => '10.13.0.0/18',
      :gateway => '10.13.63.254'
    },
    '9' => {
      :network => '10.13.64.0/18',
      :gateway => '10.13.127.254'
    },
    '13' => {
      :network => '10.15.192.0/18',
      :gateway => '10.15.255.254'
    },
  })

end
