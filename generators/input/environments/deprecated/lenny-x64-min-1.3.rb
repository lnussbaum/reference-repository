environment 'lenny-x64-min-1.3' do
  state "deprecated"
  file({:path => "/grid5000/images/lenny-x64-min-1.3.tgz", :md5 => "27230eef11834d41d8610c19c9076f12"})
  kernel "2.6.26.2"
  available_on %w{}
  valid_on "bordeplage , bordereau , borderline ,  adonis , edel , genepi , chicon , chimint , chinqchint , chirloute , granduc , hercule, orion, sagittaire, taurus, graphene , griffon , stremi , paradent , paramount , parapide , parapluie , helios , sol , suno, pastel"
  based_on "Debian version lenny for amd64"
  consoles [{:port => "ttyS0", :bps => 34800}]
  services []
  accounts [{:login => "root", :password => "grid5000"}]
  applications "Vim, nano, Perl".split(", ")
  x11_forwarding true
  tcp_bandwidth 1.G
end