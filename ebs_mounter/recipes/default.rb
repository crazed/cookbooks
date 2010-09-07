# some requirements
include_recipe "aws"
package "lvm2"
package "xfsprogs"
begin
	aws = data_bag_item("aws", "main")
	Chef::Log.info("Loaded AWS information from DataBagItem aws[#{aws['id']}]")
rescue
	Chef::Log.fatal("Could not find the 'main' item in the 'aws' data bag")
	raise
end
# check 'knife data bag show aws main' for contents

# setup some variables
vg_name = node.default[:ebs][:vg_name]
lv_name = node.default[:ebs][:lv_name]
ebs_volumes = node.default[:ebs][:devices]

# command to make the file system and mount
execute "mkfs.xfs" do
        command "mkfs.xfs /dev/#{vg_name}/#{lv_name} && mount -t xfs /dev/#{vg_name}/#{lv_name} /ebs"
        action :nothing
end

# setup the mount point
directory "/ebs" do
        action :create
end

# commands to create volume groups and logical volumes
execute "create_vg" do
        command "vgcreate #{vg_name} %s" % ebs_volumes.join(' ')
        action :nothing
end

execute "create_lv" do
        command "lvcreate -i%d -I4 -l 100%%FREE -n %s %s" % [ebs_volumes.length, lv_name, vg_name]
        action :nothing
	notifies :run, resources(:execute => "mkfs.xfs")
end

# commands for pvcreate
ebs_volumes.each do |volume|
	execute "pvcreate #{volume}" do
		action :nothing
	end
end

# setup each ebs volume
ebs_volumes.each_with_index do |volume, index|
	aws_ebs_volume volume do
		aws_access_key aws['aws_access_key_id']
		aws_secret_access_key aws['aws_secret_access_key_id']
		size 1
		device volume
		action [ :create, :attach ]
		notifies :run, resources(:execute => "pvcreate #{volume}")
		if index == (ebs_volumes.length - 1):
			# once the volumes exist, create a volume group and logical volume
			notifies :run, resources(:execute => "create_vg")
			notifies :run, resources(:execute => "create_lv")
		end
	end
end
