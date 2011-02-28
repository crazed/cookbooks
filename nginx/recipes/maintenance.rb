case node.platform
when 'ubuntu'
  www_user = 'www-data'
  www_group = 'www-data'
else
  Chef::Log.fatal("Your platform is not supported: #{node.platform}")
  raise
end

case File.exists?("#{node.www.document_root}/maintenance.html")
when true
  execute "rm -f #{node.www.document_root}/maintenance.html"
else
  ruby_block 'create maintenance page' do
    block do
      File.open("#{node.www.document_root}/maintenance.html", 'w') { |f| f.write(node.nginx.maintenance_html) }
    end
  end
end
