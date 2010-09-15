#
# Cookbook Name:: s3cmd
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "s3cmd"
begin
  aws_config = data_bag_item(node.default[:client_name], "aws")
  Chef::Log.info("Loaded AWS information from DataBagItem #{node.default[:client_name]}[#{aws_config['id']}]")
rescue
  Chef::Log.fatal("Could not find the 'aws' item in the '#{node.default[:client_name]}' data bag")
  raise
end

template "/etc/s3cfg.conf" do
  source "s3cfg.erb"
  variables(:passphrase => aws_config['s3_passphrase'], 
    :aws_secret_access_key_id => aws_config['aws_secret_access_key_id'],
    :aws_access_key_id => aws_config['aws_access_key_id'])
  owner "root"
  group "root"
  mode 600
end
