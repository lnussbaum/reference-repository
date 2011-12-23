site :luxembourg do |site_uid|
  name "Luxembourg"
  location "Luxembourg, France"
  web "https://www.grid5000.fr/mediawiki/index.php/Luxembourg:Home"
  description ""
  latitude 49.1000
  longitude 6.6667
  email_contact "luxembourg-staff@lists.grid5000.fr"
  sys_admin_contact "luxembourg-staff@lists.grid5000.fr"
  security_contact "luxembourg-staff@lists.grid5000.fr"
  user_support_contact "luxembourg-staff@lists.grid5000.fr"
  ( %w{sid-x64-base-1.0 sid-x64-base-1.1 sid-x64-nfs-1.0 sid-x64-nfs-1.1 sid-x64-big-1.1} +
    %w{etch-x64-base-1.0 etch-x64-base-1.1 etch-x64-nfs-1.0 etch-x64-nfs-1.1 etch-x64-big-1.0 etch-x64-big-1.1 etch-x64-base-2.0 etch-x64-nfs-2.0 etch-x64-big-2.0} +
    %w{lenny-x64-base-0.9 lenny-x64-nfs-0.9 lenny-x64-big-0.9 lenny-x64-base-1.0 lenny-x64-nfs-1.0 lenny-x64-big-1.0 lenny-x64-base-2.0 lenny-x64-nfs-2.0 lenny-x64-big-2.0} +
    %w{lenny-x64-base-2.3 lenny-x64-big-2.3 lenny-x64-min-0.8 lenny-x64-nfs-2.3 lenny-x64-xen-2.3}  ).each{|env_uid| environment env_uid, :refer_to => "grid5000/environments/#{env_uid}"}
 compilation_server false

end