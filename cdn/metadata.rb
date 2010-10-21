maintainer       "Datapipe"
maintainer_email "afeid@datapipe.com"
license          "All rights reserved"
description      "Installs/Configures cdn"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe "cdn::varnish", "Configures the Varnish caching server"
recipe "cdn::nginx", "Configures nginx to pull/store static content from the origin server"
attribute	'origin',
  :display_name => "Cache Origin Server",
  :description => "The FQDN of your origin server",
  :type => "string",
  :required => "required",
  :recipes => [ 'cdn::nginx' ]
