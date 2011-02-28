#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2010, Datapipe
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server"

service "mysql" do
  action [ :start, :enable ]
end

execute "set root pw" do
  command "mysql < /tmp/rootpw.sql && rm -f /tmp/rootpw.sql"
  action :nothing
end

template "/tmp/rootpw.sql" do
  source "sql.erb"
  owner "root"
  group "root"
  mode "600"
  variables(:password => node.mysql.rootpw)
  notifies :run, resources(:execute => "set root pw"), :immediately
end

template "/root/.my.cnf" do
  source "my-cnf.erb"
  owner "root"
  group "root"
  mode "600"
  variables(:user => "root", :password => node.mysql.rootpw)
end
