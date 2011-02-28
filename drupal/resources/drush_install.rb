actions :run
attribute :dir, :kind_of => String, :name_attribute => true, :required => true
attribute :modules, :kind_of => Array
attribute :mysql_user, :kind_of => String, :required => true
attribute :mysql_password, :kind_of => String, :required => true
attribute :mysql_hostname, :kind_of => String, :required => true
attribute :mysql_database, :kind_of => String, :required => true
attribute :core, :kind_of => String, :required => true
