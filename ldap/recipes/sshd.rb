service 'ssh' do
  running true
end

template '/etc/ssh/sshd_config' do
  backup false
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, resources(:service => 'ssh'), :immediately
end
