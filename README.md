Cookbooks by crazed
===================

Here's some cookbooks I've written for Opscode Chef. I'll try to keep them updated, but patches/suggestions are always welcome. Also it should be noted I'm a sysadmin not a true developer ;)

zabbix
------
 * uses the zabbix api written for ruby 
 * creates a zabbix_agent resource/provider

haproxy
-------
 * assigns EIP from aws eip_load_balancer_prod databag
 * uses a databag similar to this for server configuration

    $ knife data bag show my-awesome-company application
    {
      "repo": "git://git.hackerna.me/myapp.git",
      "id": "application",
      "revision": "HEAD",
      "deploy": false,
      "deploy_to": "/srv/myapp",
      "prod_role": "myapp-server"
    }

install_webapp
--------------
 * uses a data bag like the above for deployment info
 * will only deploy when "deploy" is set to true

ebs_mounter
-----------
 * creates as many EBS volumes as described in the attributes file
 * stripes the volumes with LVM
 * creates an XFS file system and mounts it 

php-fpm
-------
 * adds a PPA to install php-fpm on Ubuntu

nginx
-----
 * installs and configures nginx
