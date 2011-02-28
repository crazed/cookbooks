# note: you have to specify full path to s3cmd as rightscale includes their own, older version of s3cmd

include_recipe "s3cmd::default"

execute "make_bucket" do
  not_if "/usr/bin/s3cmd ls | awk '{print $3}' |  grep -e ^#{node.s3_bucket}$"
  command "/usr/bin/s3cmd mb #{node.s3_bucket}"
end

# make sure the directory exists
directory node.code_path do
  recursive true
end

execute "s3sync" do
  command "/usr/bin/s3cmd sync #{node.s3_bucket}/ #{node.code_path}"
end

cron "s3sync" do
  minute "*/#{node.sync_minutes}"
  command "/usr/bin/s3cmd sync #{node.s3_bucket}/ #{node.code_path}"
end
