include_recipe 'ldap::auth'

case node.platform
when 'ubuntu'
  # in order to remove the current sudo binary,
  # ubuntu requires you to set this environment variable
  ENV['SUDO_FORCE_REMOVE'] = 'yes'

  # these files are the same, so just symlink them,
  # we can't execute this until after the package exists
  execute 'symlink sudo-ldap.conf' do
    command 'rm -f /etc/sudo-ldap.conf && ln -s /etc/ldap.conf /etc/sudo-ldap.conf'
    action :nothing
  end

  package 'sudo-ldap' do
    notifies :run, resources(:execute => 'symlink sudo-ldap.conf'), :immediately
  end

  package 'nslcd' # package needed to properly use sudo in ldap

  # setup nsswitch.conf to use ldap for sudo
  template '/etc/nsswitch.conf' do
    source 'nsswitch.conf.erb'
    owner 'root'
    group 'root'
    mode '644'
  end
else
  Chef::Log.fatal("Your platform is not supported: #{node.platform}")
  raise
end
