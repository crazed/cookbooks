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

# setup a command to add new ppa
execute "add-apt-repository" do
        command "add-apt-repository ppa:brianmercer/php && apt-get update"
        action :run
end

# take care of all the php packages
package "php5-common" do
	action :install
end

package "php5-mysql" do
	action :install
end

package "php5-suhosin" do
	action :install
end

package "php5-gd" do
	action :install
end

package "php5-fpm" do
	action :install
end

package "php-pear" do
	action :install
end

package "php5-memcache" do
	action :install
end

package "php-apc" do
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

# start up php-fpm
service "php5-fpm" do
	supports :restart => true
	action [ :enable, :start ]
end
