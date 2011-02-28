include_recipe 'nginx::default'

service 'nginx' do
  running true
end

template '/etc/nginx/sites-available/default' do
  source 'nginx-vhost.conf.erb'
  variables(
    :document_root => node.www.document_root,
    :server_name => node.www.server_name
  )
  notifies :restart, resources(:service => 'nginx'), :immediately
end
