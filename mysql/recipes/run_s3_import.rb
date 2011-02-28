include_recipe "mysql::default"
include_recipe "s3cmd::default"

case node.mysql.dumps_bucket_file
when /^(.*)\.gz/
  s3cmd_get "/tmp/import.sql.gz" do
    bucket node.mysql.dumps_bucket
    s3_file_path node.mysql.dumps_bucket_file
    action :run
  end
  execute "decompress dump file" do
    command "gunzip /tmp/import.sql.gz"
  end
when /^(.*)\.bz2/
  s3cmd_get "/tmp/import.sql.bz2" do
    bucket node.mysql.dumps_bucket
    s3_file_path node.mysql.dumps_bucket_file
    action :run
  end
  execute "decompress dump file" do
    command "bunzip2 /tmp/import.sql.bz2"
  end
else 
  s3cmd_get "/tmp/import.sql" do
    bucket node.mysql.dumps_bucket
    s3_file_path node.mysql.dumps_bucket_file
    action :run
  end
end

mysql_import "/tmp/import.sql" do 
  action :run
end

execute "cleanup" do
  command "rm -f /tmp/import.sql"
end
