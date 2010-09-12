begin
  #require 'zabbixapi.rb'
rescue
  Chef::Log.warn("Missing zabbixapi!")
end

module Opscode
  module Zabbix
    module Agent
      def create_host(server="",user="",pass="",host="",ip="",port=10050)
        zbx_api = ZbxAPI.new(server)
        zbx_api.login(user, pass)
        if zbx_api.loggedin? then
          Chef::Log.info("Successfully logged into zabbix API")
        else
          Chef::Log.fatal("Error logging into zabbix API")
        end
        # check if the host already exists, if not add it
        #check_host = zbx_api.host.get("pattern" => host)
        if zbx_api.host.get("pattern" => host)[0] != nil then
          Chef::Log.debug("Host '#{host}' already exists, not creating..")
        else
          Chef::Log.debug("Creating the host...")
          zbx_api.host.create(
            "host" => host,
            "ip" => ip,
            "port" => port,
            "useip" => 1,
            "groups" => [ { "groupid" => 2 }])
        end
      end
    end
  end
end
