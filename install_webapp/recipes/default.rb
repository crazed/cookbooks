#
# Cookbook Name:: install_webapp
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

app_info = data_bag_item(node.default[:webapp][:bag], node.default[:webapp][:name])

# check if this server already has app data
unless File.directory?(app_info['deploy_to'])
	new_server = true
end

package "git-core" do
	action :install
end

directory "#{app_info['deploy_to']}/shared" do
	recursive true
	action :create
end

if app_info['deploy'] || new_server
	Chef::Log.info("Running a deployment..")
	deploy app_info['deploy_to'] do
		repo app_info['repo']
		branch app_info['revision']
		enable_submodules true
		# remove rails specific stuff
		@purge_before_symlink = %w{}
		@create_dirs_before_symlink  = %w{}
		@symlinks = {}
		@symlink_before_migrate = {}
		migrate false
		action :deploy
	end
end
