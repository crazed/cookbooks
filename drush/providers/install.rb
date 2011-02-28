action :install do
  template '/tmp/drush.make' do
    source 'drush.make.erb'
    variables(
      :projects => new_resource.modules
    )
  end

  directory new_resource.dir do
    owner 'root'
    group 'root'
    mode '755'
    recursive true
  end

  execute 'drush make' do
    creates "#{new_resource.dir}/index.php"
    command "drush make /tmp/drush.make #{new_resource.dir}"
  end

  execute 'drush install' do
    creates "#{new_resource.dir}/sites/default/settings.php"
    command "drush -r #{new_resource.dir} site-install --db-url=mysql://#{new_resource.mysql_user}:#{new_resource.mysql_password}@#{new_resource.mysql_hostname}/#{new_resource.mysql_database}"
  end
end
