maintainer       "Datapipe"
maintainer_email "afeid@datapipe.com"
license          "All rights reserved"
description      "Installs/Configures ldap"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe "ldap::auth", "configures an instance for LDAP authentication"
recipe 'ldap::sudoers', 'configures an instance to use LDAP for sudoers'
recipe 'ldap::sshd', 'Configures sshd to allow password logins'
attribute 'ldap/bind_dn',
  :display_name => 'LDAP Bind DN',
  :description => 'The DN to bind as for lookups in LDAP',
  :type => 'string',
  :recipes => [ 'ldap::auth' ],
  :required => 'required'
attribute 'ldap/bind_pw',
  :display_name => 'LDAP Bind Password',
  :description => 'The password for the bind DN',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'ldap::auth' ]
attribute 'ldap/base_dn',
  :display_name => 'LDAP Base DN',
  :description => 'The base DN for LDAP lookups',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'ldap::auth' ]
attribute 'ldap/uri',
  :display_name => 'LDAP Server URIs',
  :description => 'Space delimited list of ldap servers with their URI, ex: ldap://ldap1.example.com',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'ldap::auth' ]
attribute 'ldap/cacert_url',
  :display_name => 'LDAP CA Cert URL',
  :description => 'The URL which has the CA Certificate for LDAP servers',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'ldap::auth' ]
