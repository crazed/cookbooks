include_recipe 'drush::default'
drush_install node.www.document_root do
  core '7.0'
  modules 'pathauto'
  action :install
end
