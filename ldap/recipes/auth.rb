# use our custom provider to configure ldap authentication
ldap_auth_setup node.ldap.base_dn do
  bind_dn node.ldap.bind_dn
  bind_pw node.ldap.bind_pw
  ldap_uri node.ldap.uri
  cacert_url node.ldap.cacert_url
  action :install
end
