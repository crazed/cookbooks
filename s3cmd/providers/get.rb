action :run do
  execute "s3cmd get" do
    command "/usr/bin/s3cmd get --force s3://#{new_resource.bucket}#{new_resource.s3_file_path} #{new_resource.download_path}"
  end
end
