#
# Cookbook Name:: ldap_auth
# Recipe:: default
#
# Copyright 2010, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "auth-client-config"
package "ldap-auth-config"

ldap_cert_dir = "/etc/ldap/keys"

# grab some config vars from a data bag
begin
  ldap_config = data_bag_item(node.default[:client_name], "ldap_auth")
  Chef::Log.info("Loaded LDAP config options from DataBagItem #{node.default[:client_name]}[#{ldap_config[id]}]")
rescue
  Chef::Log.fatal("Could not find the 'ldap_auth' item in the '#{node.default[:client_name]}' data bag")
  raise
end

# setup the auth-client-config profile
template "/etc/auth-client-config/profile.d/ldap-auth-config" do
  owner "root"
  group "root"
  mode "755"
  source "ldap-auth-config.erb"
end

# setup ldap.conf for authentication
template "/etc/ldap.conf" do
  owner "root"
  group "root"
  mode "755"
  cacert = '/etc/ldap/keys/cacert.pem'
  variables(:base_dn => ldap_config['basedn'], :cacert => '/etc/ldap/keys/cacert.pem', :uri => ldap_config['uri'])
  source "ldap.conf.erb"
end

# grab the file (requires s3cmd recipe)
execute "get_cacert" do  command "s3cmd -c /etc/s3cfg.conf get s3://#{ldap_config['cacert_bucket']}/#{ldap_config['cacert_path']} #{ldap_cert_dir}"
  action :nothing
end

# make sure the ldap keys directory exists
directory ldap_cert_dir do
  owner "root"
  group "root"
  action :create
  notifies :run, resources(:execute => "get_cacert")
end

# enable ldap auth
execute "auth-client-config" do
  command "auth-client-config -a -p lac_ldap"
end
