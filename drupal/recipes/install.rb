include_recipe 'drupal::default'
drupal_drush_install node.www.document_root do
  dir node.www.document_root
  core node.drupal.version
  modules node.drupal.modules if node[:drupal][:modules]
  mysql_user node.mysql.user
  mysql_password node.mysql.password
  mysql_hostname node.mysql.hostname
  action :run
end
