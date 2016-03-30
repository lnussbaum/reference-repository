environment 'squeeze-x64-min-1.3' do
  state "stable"
  file({:path => "/grid5000/images/squeeze-x64-min-1.3.tgz", :md5 => "ef44ce402c92acdaa51badcddbe20e6d"})
  kernel "2.6.32-5"
  available_on %w{bordeaux grenoble lille luxembourg lyon nancy reims rennes sophia toulouse}
  valid_on "bordeplage , bordereau , borderline ,  adonis , edel , genepi , chicon , chimint , chinqchint , chirloute , granduc , sagittaire , graphene , griffon , stremi , paramount , parapide , parapluie , helios , sol , suno, pastel"
  based_on "Debian version squeeze for amd64"
  consoles [{:port => "ttyS0", :bps => 34800}]
  services []
  accounts [{:login => "root", :password => "grid5000"}]
  applications %w{Vim nano Perl}
  x11_forwarding true
  tcp_bandwidth 1.G
end