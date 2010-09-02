#
# Cookbook Name:: nginx-web-stack
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# start off with nginx
package "nginx" do
	action :install
end

# setup the document root
directory "/var/www/vhosts/default" do
	owner "www-data"
	group "www-data"
	mode "0755"
	recursive true
	action :create
end

# drop a default index page in
execute "default-index-page" do
        command "echo '<?php phpinfo(); ?>' > /var/www/vhosts/default/index.php"
        action :run
end

# default nginx configuration
template "/etc/nginx/sites-available/default" do
	source "nginx-default.erb"
end

# stop/disable apache2 (this is on by default from the ubuntu ami)
service "apache2" do
	supports :status => true, :restart => true
	action [ :disable, :stop ]
end

# start up nginx
service "nginx" do
	supports :status => true, :restart => true
	action [ :enable, :start ]
end
