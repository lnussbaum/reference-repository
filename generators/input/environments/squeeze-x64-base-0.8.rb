environment 'squeeze-x64-base-0.8' do
  state "stable"
  file({:path => "/grid5000/images/squeeze-x64-base-0.8.tgz", :md5 => "105bd08ea3f3bf4888d371c9a3241ee5"})
  kernel "2.6.32-5"
  available_on %w{bordeaux grenoble lille lyon nancy orsay reims rennes sophia toulouse}
  valid_on "bordeplage , bordereau , borderline ,  adonis , edel , genepi , chicon , chimint , chinqchint , chirloute , capricorne , sagittaire , graphene , griffon , gdx , netgdx , stremi , paramount , parapide , parapluie , helios , sol , suno, pastel , violette"
  based_on "Debian version squeeze for amd64"
  consoles [{:port => "ttyS0", :bps => 34800}]
  services []
  accounts [{:login => "root", :password => "grid5000"}]
  applications %w{Vim XEmacs JED nano JOE Perl Python Ruby}
  x11_forwarding true
  max_open_files 8192
  tcp_bandwidth 1.G
end
