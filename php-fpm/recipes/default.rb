#
# Cookbook Name:: nginx-web-stack
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


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

# start up php-fpm
service "php5-fpm" do
	supports :restart => true
	action [ :enable, :start ]
end
