maintainer       "Datapipe"
maintainer_email "afeid@datapipe.com"
license          "All rights reserved"
description      "Installs/Configures cdn"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
attribute	'origin',
  :display_name => "Cache Origin Server",
  :description => "The FQDN of your origin server",
  :type => "string",
  :required => "required"
