action :run do
  case new_resource.database
  when nil
    execute "mysql full import" do
      command "mysql < #{new_resource.dump_file}"
    end
  else
    execute "mysql database import" do
      command "mysql #{new_resource.database} < #{new_resource.dump_file}"
    end
  end
end
