#
# Cookbook Name:: php-fpm
# Recipe:: default
#
# Copyright 2010, Datapipe
#
# All rights reserved - Do Not Redistribute
#

# hash containing all values for php-fpm's dynamic process creation
tuning = Hash.new { |hash,key| hash[key] = Hash.new }
tuning['t1.micro']['max_children'] = 5
tuning['t1.micro']['min_spare'] = 2
tuning['t1.micro']['max_spare'] = 4

tuning['m1.small']['max_children'] = 15
tuning['m1.small']['min_spare'] = 5
tuning['m1.small']['max_spare'] = 10

tuning['m1.large']['max_children'] = 68
tuning['m1.large']['min_spare'] = 6
tuning['m1.large']['max_spare'] = 12

tuning['m1.xlarge']['max_children'] = 136
tuning['m1.xlarge']['min_spare'] = 12
tuning['m1.xlarge']['max_spare'] = 24

tuning['m2.xlarge']['max_children'] = 155
tuning['m2.xlarge']['min_spare'] = 15
tuning['m2.xlarge']['max_spare'] = 30

tuning['m2.2xlarge']['max_children'] = 310
tuning['m2.2xlarge']['min_spare'] = 30
tuning['m2.2xlarge']['max_spare'] = 60

tuning['m2.4xlarge']['max_children'] = 310
tuning['m2.4xlarge']['min_spare'] = 30
tuning['m2.4xlarge']['max_spare'] = 60

tuning['c1.medium']['max_children'] = 15
tuning['c1.medium']['min_spare'] = 5
tuning['c1.medium']['max_spare'] = 10

tuning['c1.xlarge']['max_children'] = 68
tuning['c1.xlarge']['min_spare'] = 6
tuning['c1.xlarge']['max_spare'] = 12

# setup a command to add new ppa
package "python-software-properties"
execute "add-apt-repository" do
        command "add-apt-repository ppa:brianmercer/php && apt-get update"
        action :run
end

# take care of all the php packages
package "php5-common"
package "php5-mysql"
package "php5-suhosin"
package "php5-gd"
package "php5-fpm" 
package "php-pear" 
package "php5-memcache" 
package "php-apc" 

# start up php-fpm
service "php5-fpm" do
  supports :restart => true
  action [ :enable, :start ]
end

template "/etc/php5/fpm/php5-fpm.conf" do
  source "php5-fpm.erb"
  variables(
    :max_children => tuning[node.ec2.instance_type]['max_children'],
    :min_spare => tuning[node.ec2.instance_type]['min_spare'],
    :max_spare => tuning[node.ec2.instance_type]['max_spare']
  )
  notifies :restart, resources(:service => "php5-fpm"), :immediately
end
