action :install do
  ldap_cert_dir = nil
  case node.platform
  when 'ubuntu'
    ldap_cert_dir = '/etc/ldap/certs'
    package 'auth-client-config'
    package 'ldap-auth-config'
    template '/etc/ldap.conf' do
      owner 'root'
      group 'root'
      mode '644'
      source 'ldap.conf.erb'
      variables(
        :base_dn => new_resource.base_dn,
        :cacert => "#{ldap_cert_dir}/cacert.pem",
        :uri => new_resource.ldap_uri,
        :bind_dn => new_resource.bind_dn,
        :bind_pw => new_resource.bind_pw
      )
    end
    template '/etc/nslcd.conf' do
      owner 'root'
      group 'root'
      mode '644'
      source 'nslcd.conf.erb'
      variables(
        :base_dn => new_resource.base_dn,
        :cacert => "#{ldap_cert_dir}/cacert.pem",
        :uri => new_resource.ldap_uri,
        :bind_dn => new_resource.bind_dn,
        :bind_pw => new_resource.bind_pw
      )
    end
    template '/etc/auth-client-config/profile.d/ldap-auth-config' do
      # auth-client-config loads via glob in profile.d/, turn off backups to prevent issues
      backup false
      owner 'root'
      group 'root'
      mode '644'
      source 'ldap-auth-config.erb'
    end
  else
    Chef::Log.fatal("Your platform is not supported: #{node.platform}")
    raise
  end

  directory ldap_cert_dir do
    owner 'root'
    group 'root'
    action :create
  end

  execute 'enable ldap authentication' do
    case node.platform
    when 'ubuntu'
      command 'auth-client-config -a -p lac_ldap'
    end
  end

  execute 'get ca certificate' do
    command "wget -O #{ldap_cert_dir}/cacert.pem #{new_resource.cacert_url}"
    creates "#{ldap_cert_dir}/cacert.pem"
    notifies :run, resources(:execute => 'enable ldap authentication'), :immediately
  end
end
