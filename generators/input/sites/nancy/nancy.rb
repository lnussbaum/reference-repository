site :nancy do |site_uid|
  name "Nancy"
  location "Nancy, France"
  web "http://www.loria.fr"
  description "Grid5000 Nancy site"
  latitude 48.7000
  longitude 6.2000
  email_contact "support-staff@lists.grid5000.fr"
  sys_admin_contact "support-staff@lists.grid5000.fr"
  security_contact "support-staff@lists.grid5000.fr"
  user_support_contact "support-staff@lists.grid5000.fr"
  compilation_server false
  kavlan_ip_range "10.16.0.0/14"
  virt_ip_range "10.144.0.0/14"
  storage5k true
  production true

  g5ksubnet({
    :network => '10.144.0.0/14',
    :gateway => '10.147.255.254'
  })

  kavlans({
    'default' => {
      :network => '172.16.64.0/20',
      :gateway => '172.16.79.254'
    },
    '1' => {
      :network => '192.168.192.0/20',
      :gateway => '172.16.79.120'
    },
    '2' => {
      :network => '192.168.208.0/20',
      :gateway => '172.16.79.121'
    },
    '3' => {
      :network => '192.168.224.0/20',
      :gateway => '172.16.79.122'
    },
    '4' => {
      :network => '10.16.0.0/18',
      :gateway => '10.16.63.254'
    },
    '5' => {
      :network => '10.16.64.0/18',
      :gateway => '10.16.127.254'
    },
    '6' => {
      :network => '10.16.128.0/18',
      :gateway => '10.16.191.254'
    },
    '7' => {
      :network => '10.16.192.0/18',
      :gateway => '10.16.255.254'
    },
    '8' => {
      :network => '10.17.0.0/18',
      :gateway => '10.17.63.254'
    },
    '9' => {
      :network => '10.17.64.0/18',
      :gateway => '10.17.127.254'
    },
    '14' => {
      :network => '10.19.192.0/18',
      :gateway => '10.19.255.254'
    },
  })

end
