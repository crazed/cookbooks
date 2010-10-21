package "nginx"

service "nginx" do
  supports :reload => true, :restart => true
  action [ :enable ]
end

template "/etc/nginx/conf.d/proxy.conf" do
  owner "root"
  group "root"
  mode "644"
  notifies :restart, resources(:service => "nginx")
  source "default.erb"
  variables(:origin => node.default.origin)
end
