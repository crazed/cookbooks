include_recipe 'mysql::default'
execute "mysql grants" do
  command "mysql --defaults-file=/root/.my.cnf < /tmp/grants.sql && rm -f /tmp/grants.sql"
  action :nothing
end

template "/tmp/grants.sql" do
  not_if "echo 'show databases' | mysql | grep #{node.mysql.database}"
  source "grants.erb"
  variables(:user => node.mysql.user, :pass => node.mysql.password, :database => node.mysql.database)
  notifies :run, resources(:execute => "mysql grants"), :immediately
end
