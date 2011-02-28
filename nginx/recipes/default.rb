#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2010, Datapipe
#
# All rights reserved - Do Not Redistribute
#

# start off with nginx
package "nginx"

# setup the document root
directory node.www.document_root do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
  action :create
end

# default nginx configuration
template "/etc/nginx/sites-available/default" do
  source "nginx-default.erb"
  variables(
    :document_root => node.www.document_root,
    :server_name => node.nginx.server_name
  )
end

# nginx.conf, set the processes to total cpu cores
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  variables(:processes => node.cpu.total)
end

# kill apache2 if it's there
service "apache2" do
  only_if "pgrep apache2"
  action [ :disable, :stop ]
end

# start up nginx
service "nginx" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

# fix some log rotation
remote_file '/etc/logrotate.d/nginx' do
  source 'nginx-logrotate'
  owner 'root'
  group 'root'
  mode '644'
end
