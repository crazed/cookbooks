maintainer       "Datapipe"
maintainer_email "afeid@datapipe.com"
license          "All rights reserved"
description      "Installs/Configures mysql"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe "mysql::default", "Installs mysql-server"
recipe "mysql::new_database", "Configures a new database"
recipe "mysql::backup", "Installs a nightly cronjob that performs database dumps to an S3 bucket"
recipe "mysql::run_s3_import", "Imports MySQL dump from an S3 bucket"
attribute 'mysql/rootpw',
  :display_name => "MySQL Root Password",
  :required => "required",
  :recipes => [ 'mysql::default' ]
attribute 'mysql/user',
  :display_name => 'MySQL User',
  :description => 'A regular mysql user, used typically for application level database access.',
  :default => 'user',
  :recipes => [ 'mysql::new_database' ]
attribute 'mysql/password',
  :display_name => 'MySQL User Password',
  :description => 'The password for a regular MySQL user.',
  :required => 'required',
  :recipes => [ 'mysql::new_database' ]
attribute 'mysql/database',
  :display_name => 'MySQL User Database',
  :description => 'New database that will a new user will have full access to.',
  :default => 'user_db',
  :recipes => [ 'mysql::new_database']
attribute 'mysql/dumps_bucket',
  :display_name => 'MySQL Dumps S3 Bucket',
  :description => 'S3 bucket to place mysql dumps in',
  :required => 'required',
  :recipes => [ 'mysql::backup', 'mysql::run_s3_import' ]
attribute 'mysql/dumps_bucket_path',
  :display_name => 'MySQL Dumps S3 Path',
  :description => 'The path relative to your s3 bucket to store dumps',
  :default => '/',
  :recipes => [ 'mysql::backup' ]
attribute 'mysql/dumps_bucket_file',
  :display_name => 'MySQL S3 File Path',
  :description => 'Dump file path to import',
  :default => '/latest.sql',
  :recipes => [ 'mysql::run_s3_import' ]
