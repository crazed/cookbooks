action :run do
  template '/tmp/drush.make' do
    source 'drush.make.erb'
    variables(
      :projects => new_resource.modules,
      :core => new_resource.core
    )
  end

  execute 'drush make' do
    creates "#{new_resource.dir}/index.php"
    command "drush make /tmp/drush.make #{new_resource.dir}"
  end

  execute 'drush install' do
    creates "#{new_resource.dir}/sites/default/settings.php"
    command "drush -r #{new_resource.dir} -y site-install --db-url=mysql://#{new_resource.mysql_user}:#{new_resource.mysql_password}@#{new_resource.mysql_hostname}/#{new_resource.mysql_database}"
  end

  execute 'drush enable modules' do
    command "drush -r #{new_resource.dir} -y pm-enable #{new_resource.modules.join(' ')}"
  end

  execute 'files dir permissions' do
    command "chown -R www-data:www-data #{new_resource.dir}/sites/default/files"
  end
end
