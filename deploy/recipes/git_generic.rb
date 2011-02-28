#
# Cookbook Name:: deploy
# Recipe:: git_generic
#

deploy node.deploy.dir do
  repo node.deploy.repo
  branch node.deploy.branch
  enable_submodules true
  # remove rails specific stuff
  @purge_before_symlink = %w{}
  @create_dirs_before_symlink = %w{}
  @symlinks = {}
  @symlink_before_migrate = {}
  migrate false
  action :deploy
end
