#
# Cookbook Name:: services
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "ssh" do
	case node[:platform]
	when "CentOS", "RedHat", "fedora"
		service_name "sshd"
	else
		service_name "ssh"
	end
	supports :restart => true, :status => true
	action [ :enable, :start ]
end

service "ntp" do
	case node[:platform]
	when "CentOS", "RedHat", "fedora"
		service_name "ntpd"
	else
		service_name "ntp"
	end
	supports :restart => true, :status => true
	action [ :enable, :start ]
end

package "nfs" do
	case node[:platform]
	when "CentOS", "RedHat", "fedora"
		package_name "nfs-utils"
	else
		package_name "nfs-common"
	end
	action :install
end

directory "/export/media" do
	owner "root"
	group "root"
	mode "0755"
	recursive true
	action :create
end

mount "/export/media" do
	device "nas.crazy.lan:/tank/media"
	fstype "nfs4"
	options "rw"
	action [:mount, :enable]
end
