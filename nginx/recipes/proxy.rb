if node.platform != 'ubuntu'
  Chef::Log.fatal("Your platform is not supported: #{node.platform}")
  raise
end

package 'nginx'
service 'nginx' do
  running true
end

directory node.nginx.document_root do
  owner 'www-data'
  group 'www-data'
  mode '755'
  recursive true
  action :create
end

template '/etc/nginx/sites-available/default' do
  owner 'root'
  group 'root'
  mode '644'
  source 'nginx-proxy.erb'
  variables(
    :proxy => node.nginx.proxy,
    :document_root => node.nginx.document_root
  )
  notifies :restart, resources(:service => 'nginx'), :immediately
end

template "/etc/nginx/nginx.conf" do
  owner 'root'
  group 'root'
  mode '644'
  source "nginx.conf.erb"
  variables(:processes => node.cpu.total)
  notifies :restart, resources(:service => 'nginx'), :immediately
end
