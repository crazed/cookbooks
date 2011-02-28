directory "/dumps" do
  action :create
end

# grab any existing dumps
execute "s3cmd sync s3://#{node.mysql.dumps_bucket}#{node.mysql.dumps_bucket_path}/ /dumps/"

directory "/opt/utils" do
  action :create
end

template "/opt/utils/dumper.sh" do
  source "dumper.sh.erb"
  variables(
    :s3_bucket => node.mysql.dumps_bucket,
    :s3_path => node.mysql.dumps_bucket_path
  )
  owner "root"
  group "root"
  mode "750"
end

cron "mysql dumps" do
  hour "3"
  minute "0"
  command "/opt/utils/dumper.sh"
end
