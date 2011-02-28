if node.platform != 'ubuntu'
  Chef::Log.fatal("Your platform is not supported: #{node.platform}")
  raise
end

package 'nginx'
service 'nginx' do
  running true
end

directory '/etc/nginx/ssl' do
  owner 'root'
  group 'root'
  mode '755'
  recursive true
  action :create
end

template '/etc/nginx/ssl/key.pem' do
  backup false
  source 'pem.erb'
  owner 'root'
  group 'root'
  mode '640'
  variables(:pem_data => node.nginx.ssl_key)
end

template '/etc/nginx/ssl/cert.pem' do
  backup false
  source 'pem.erb'
  owner 'root'
  group 'root'
  mode '644'
  variables(:pem_data => node.nginx.ssl_cert)
end

template '/etc/nginx/sites-available/default' do
  owner 'root'
  group 'root'
  mode '644'
  source 'nginx-ssl-termination.erb'
  variables(:load_balancer => node.nginx.load_balancer)
end

template "/etc/nginx/nginx.conf" do
  owner 'root'
  group 'root'
  mode '644'
  source "nginx.conf.erb"
  variables(:processes => node.cpu.total)
  notifies :restart, resources(:service => 'nginx'), :immediately
end
