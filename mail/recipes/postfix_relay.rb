package 'postfix'

service 'postfix' do
  running true
end

execute 'postmap' do
  command 'postmap /etc/postfix/sasl/passwd'
  action :nothing
end

template '/etc/postfix/sasl/passwd' do
  owner 'root'
  group 'root'
  mode '600'
  backup false
  source 'passwd.erb'
  variables(
    :user => node.mail.sasl_user,
    :pass => node.mail.sasl_password,
    :host => node.mail.relay_server
  )
  notifies :run, resources(:execute => 'postmap'), :immediately
end

template '/etc/postfix/main.cf' do
  owner 'root'
  group 'root'
  mode '644'
  source 'main.cf.erb'
  variables(
    :host => node.mail.relay_server,
    :port => node.mail.relay_port
  )
  notifies :restart, resources(:service => 'postfix')
end
