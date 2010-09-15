LDAP Authentication Recipe
==========================
Right now this is only working with Ubuntu 10.04, this also requires my s3cmd recipe to grab your LDAP servers CA certificate.

Setup the data bag
------------------
	$ knife data bag show my-awesome-company ldap_auth
	{
  	  "cacert_bucket": "crazed",
  	  "uri": "ldap://ldap01.somewhere.com",
  	  "cacert_path": "cacert.pem",
  	  "id": "ldap_auth",
  	  "basedn": "dc=test,dc=lan"
	}

You will need to change the attributes file, or set node[:client_name] to whatever main data bag you will be using.
