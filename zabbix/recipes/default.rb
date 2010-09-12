#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "zabbix-agent"

service "zabbix-agent" do
  supports :restart => true
  action [ :enable, :start]
end

template "/etc/zabbix/zabbix_agent.conf" do
  source "zabbix_agent.conf.erb"
  variables( :zabbix_server => node.zabbix.server )
  owner "root"
  group "root"
  mode "755"
  # probably need to restart zabbix-agent after this
  notifies :restart, resources(:service => "zabbix-agent")
end

template "/etc/zabbix/zabbix_agentd.conf" do
  source "zabbix_agentd.conf.erb"
  variables( :zabbix_server => node.zabbix.server, :host_name => node.zabbix.host )
  owner "root"
  group "root"
  mode "755"
  notifies :restart, resources(:service => "zabbix-agent")
end

zabbix_agent "http://chef.hackerna.me/zabbix" do
  user node.zabbix.user
  pass node.zabbix.pass
  host node.name
  ip node.cloud.public_ips.first
  action :monitor
end
