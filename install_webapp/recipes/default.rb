#
# Cookbook Name:: install_webapp
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git-core" do
	action :install
end

directory "/srv/myapp/shared/config" do
	recursive true
	action :create
end

deploy "/srv/myapp" do
	repo "git://git.hackerna.me/myapp.git"
	branch "HEAD"
	enable_submodules true
	# remove rails specific stuff
	@purge_before_symlink = %w{}
	@create_dirs_before_symlink  = %w{}
	@symlinks = {}
	@symlink_before_migrate = {}
	migrate false
	action :deploy
end
