include_recipe 'drush::default'
drush_install node.www.document_root do
  core node.drush.drupal_version
  modules node.drush.modules if node[:drush][:modules]
  mysql_user node.mysql.user
  mysql_password node.mysql.password
  mysql_hostname node.mysql.hostname
  action :install
end
