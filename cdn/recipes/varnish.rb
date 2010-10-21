package "varnish"

service "varnish" do
  supports :restart => true
  action :enable
end

cookbook_file "/etc/varnish/default.vcl" do
  source "default.vcl"
  mode "644"
  owner "root"
  group "root"
end

case node.platform
when "ubuntu"
  cookbook_file "/etc/default/varnish" do
    source "varnish-default"
    mode "644"
    owner "root"
    group "root"
    notifies :restart, resources(:service => "varnish")
  end
end
