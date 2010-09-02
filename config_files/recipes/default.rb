#
# Cookbook Name:: config_files
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/resolv.conf" do
	source "resolv.conf.erb"
	variables({
		:nameserver => node[:nameserver],
		:domain => node[:domain],
		:search => node[:search],
	})
end

template "/etc/ntp.conf" do
	source "ntp.conf.erb"
	variables :ntp_servers => node[:ntp_servers]
end

package "sudo"  do
  action :upgrade
end
 
template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables({
    :sudoers_groups => node[:authorization][:sudo][:groups],
    :sudoers_users => node[:authorization][:sudo][:users]
  })
end

