#
# Cookbook Name:: drush
# Recipe:: default
#
# Copyright 2011, Datapipe
#
# All rights reserved - Do Not Redistribute
#

bash 'install drush' do
  creates '/usr/local/bin/drush'
  cwd '/tmp'
  code <<-EOH
  wget http://ftp.drupal.org/files/projects/drush-All-versions-4.2.tar.gz
  tar xzf drush-All-versions-4.2.tar.gz
  mv drush /usr/local/share
  ln -s /usr/local/share/drush.php /usr/local/bin/drush
  EOH
end
