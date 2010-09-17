#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "aws"
aws = data_bag_item("aws", "main") # add error checking here!
eip = data_bag_item("aws", "eip_load_balancer_prod") # add error checking here!

# i'm keeping the production role for app servers in a data bag
app_info = data_bag_item("my-awesome-company", "application")

aws_elastic_ip "eip_load_balancer_prod" do
	aws_access_key aws['aws_access_key_id']
	aws_secret_access_key aws['aws_secret_access_key_id']
	ip eip['public_ip']
	action :associate
end

server_list = Array.new
search(:node, "role:#{app_info['prod_role']}").each do |server|
	Chef::Log.info("Found a server: #{server} IP: #{server.cloud.private_ips.first}")
	server_list << server.cloud.private_ips.first
end
# uniq and sort the array to make sure things are the same each time a search is made
server_list.sort!
server_list.uniq!

package "haproxy" do
  action :install
end

template "/etc/default/haproxy" do
  source "haproxy-default.erb"
  owner "root"
  group "root"
  mode 0644
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:servers => server_list)
  notifies :reload, resources(:service => "haproxy")
end
