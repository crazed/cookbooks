maintainer       "Datapipe"
maintainer_email "afeid@datapipe.com"
license          "All rights reserved"
description      "Installs/Configures mail"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe 'mail::postfix_relay', 'configures postfix to relay to an outside server'
attribute 'mail/relay_server',
  :display_name => 'SMTP Relay Server',
  :description => 'The smtp relay server to use',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'mail::postfix_relay' ]
attribute 'mail/relay_port',
  :display_name => 'SMTP Relay Port',
  :description => 'The port on which your relay server runs',
  :type => 'string',
  :default => '587',
  :recipes => [ 'mail::postfix_relay' ]
attribute 'mail/sasl_user',
  :display_name => 'SMTP Relay Username',
  :description => 'The username to be used for your SMTP relay',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'mail::postfix_relay' ]
attribute 'mail/sasl_password',
  :display_name => 'SMTP Relay Password',
  :description => 'The password for your SMTP relay',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'mail::postfix_relay' ]
