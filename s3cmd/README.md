s3cmd Recipe
============
This will read a data bag for configuring AWS information, looks like this:

	$ knife data bag show my-awesome-company aws
	{
	  "aws_secret_access_key_id": "XXXXXXXXXXXXXXXXXXXXXXXX",
	  "aws_access_key_id": "XXXXXXXXXXX",
	  "id": "aws"
	}

Be sure to set node[:client_name] to whatever main data bag you will be using (attributes file or otherwise). 
