#
# Cookbook Name:: easyagent
# Recipe:: default
#
# Copyright 2010, Datapipe
#
# All rights reserved - Do Not Redistribute
#
case node.platform
when 'ubuntu'
  # grab dependencies
  %w(liblwp2 libhtml-parser-perl libxml-parser-perl libdigest-perl libsoap-lite-perl openssl expat).each do |pkg|
    package pkg
  end

  # create easyagnt user
  user "easyagnt" do
    comment "Datapipe Monitoring"
    home "/usr/local/soap"
    shell "/bin/sh"
  end

  bash "install easyagent" do
    creates "/usr/local/soap/bin/easyagent"
    user "root"
    cwd "/tmp"
    code <<-EOH
    wget http://files.storm.datapipe.com/easyagent-current.tar.gz
    wget http://files.storm.datapipe.com/install-current
    chmod 755 install-current
    ./install-current $PWD/easyagent-current.tar.gz easyagnt
    cp /usr/local/soap/install/easyagent-tcp.init.d /etc/init.d/easyagent-tcp
    chown -R easyagnt /usr/local/soap
    EOH
  end
else
  # assume EL, fix this later
  bash "install easyagent" do
    creates "/usr/local/soap/bin/easyagent"
    user "root"
    cwd "/tmp"
    code <<-EOH
    rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
    wget http://files.dpcloud.com/easyagent-1.101-1.noarch.rpm
    yum localinstall --nogpgcheck -y easyagent-1.101-1.noarch.rpm
    EOH
  end
end

service "easyagent-tcp" do
  running true
  action [:enable, :start]
end
