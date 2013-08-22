#
# Author::  Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)
# Cookbook Name:: piwik
# Recipe:: mysql
#
# Copyright 2013, Achim Rosenhagen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql"
include_recipe "mysql::ruby"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "database::mysql"

database = node['piwik']['database']['dbname']
database_user = node['piwik']['database']['username']
database_password = node['piwik']['database']['password']
database_host = node['piwik']['database']['host']
database_port = node['piwik']['database']['port']
database_connection = {
	:host => database_host,
	:port => database_port,
	:username => 'root',
	:password => node['mysql']['server_root_password']
}
# create the database
mysql_database database do
	connection database_connection
	action :create
end
# create the database user
mysql_database_user database_user do
	connection database_connection
	password database_password
	action :create
end
# grant all privileges to user on database
mysql_database_user database_user do
	connection database_connection
	database_name database
	privileges [:all]
	action :grant
end