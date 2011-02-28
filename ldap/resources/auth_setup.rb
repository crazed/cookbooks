actions :install
attribute :base_dn, :kind_of => String, :name_attribute => true
attribute :bind_dn, :kind_of => String, :required => true
attribute :bind_pw, :kind_of => String, :required => true
attribute :ldap_uri, :kind_of => String, :required => true
attribute :cacert_url, :kind_of => String, :required => true
