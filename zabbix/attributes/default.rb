default[:zabbix][:user] = 'apiuser'
default[:zabbix][:pass] = 'apiuser'
default[:zabbix][:server] = 'chef.hackerna.me'
default[:zabbix][:host] = node.name
default[:zabbix][:ip] = node.cloud.public_ips.first
