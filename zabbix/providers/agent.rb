include Opscode::Zabbix::Agent

action :monitor do
  create_host(new_resource.server, new_resource.user, new_resource.pass, new_resource.host, new_resource.ip)
end
