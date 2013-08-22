#
# Author::  Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)
# Cookbook Name:: piwik
# Recipe:: default
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

require 'digest/sha1'

group node['piwik']['group'] do
	action [ :create, :manage ]
end

user node['piwik']['user'] do
	action [ :create, :manage ]
	comment 'Piwik User'
	gid node['piwik']['group']
	home node['piwik']['home']
	shell '/usr/sbin/nologin'
	supports :manage_home => true 
end

directory node['piwik']['home'] do
	mode 0755
	recursive true
	owner node['piwik']['user']
	group node['piwik']['group']
	action :create
end

# Superuser Salt - set it statically when running on Chef Solo via attribute
unless Chef::Config[:solo] || node['piwik']['conf']['superuser']['salt']
	node.set['piwik']['conf']['superuser']['salt'] = Digest::SHA1.hexdigest(IO.read('/dev/urandom', 2048))
	node.save
end

include_recipe "piwik::mysql"

src_filename = "piwik-#{node['piwik']['version']}.tar.gz"
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}/piwik/#{node['piwik']['checksum']}"

remote_file src_filepath do
	source node['piwik']['download_url']
	checksum node['piwik']['checksum']
	owner 'root'
	group 'root'
	mode 00644
end

bash 'extract piwik' do
	cwd ::File.dirname(src_filepath)
	code <<-EOH
		mkdir -p #{extract_path}
		tar xvf #{src_filename} -C #{extract_path}
		mv #{extract_path}/piwik/* #{node['piwik']['home']}
		echo '#{node['piwik']['version']}' > #{node['piwik']['home']}/VERSION
		chown -R #{node['piwik']['user']}:#{node['piwik']['group']} #{node['piwik']['home']}
	EOH
	not_if "test `cat #{node['piwik']['home']}/VERSION` = #{node['piwik']['home']}"
	creates "#{node['piwik']['home']}/VERSION"
end

[ "#{node['piwik']['home']}/tmp",
	"#{node['piwik']['home']}/tmp/templates_c",
	"#{node['piwik']['home']}/tmp/cache",
	"#{node['piwik']['home']}/tmp/assets",
	"#{node['piwik']['home']}/tmp/tcpdf",
	"#{node['piwik']['home']}/config"
].each do |dir|
	directory dir do
		mode 0777
		owner node['piwik']['user']
		group node['piwik']['group']
		action :create
		recursive true
	end
end

if (node['piwik']['php-fpm'].attribute?('enabled') && node['piwik']['php-fpm']['enabled'])
	php_fpm 'piwik' do
	action :add
	user node['piwik']['user']
	group node['piwik']['group']
	socket true
	socket_path node['piwik']['php-fpm']['socket']
	socket_user node['piwik']['user']
	socket_group node['piwik']['group']
	socket_perms '0666'
	start_servers 2
	min_spare_servers 2
	max_spare_servers 8
	max_children 8
	terminate_timeout (node['php']['ini_settings']['max_execution_time'].to_i + 20)
	value_overrides({ 
		:error_log => "#{node['php']['fpm_log_dir']}/piwik.log"
	})
	end
end

if (node['piwik']['apache'].attribute?('install_vhost') && node['piwik']['apache']['install_vhost'])
	web_app "piwik" do
		server_name node['piwik']['apache']['domain']
		server_aliases ["www.#{node['piwik']['apache']['domain']}"]
		docroot node['piwik']['home']
		template "web_app-piwik.conf.erb"
		enable true
	end
end

if (node['piwik']['cron'].attribute?('enabled') && node['piwik']['cron']['enabled'])
	cron "run_piwik_archive" do
		minute node['piwik']['cron']['minute']
		hour node['piwik']['cron']['hour']
		day node['piwik']['cron']['day']
		month node['piwik']['cron']['month']
		weekday node['piwik']['cron']['weekday']
		user node['apache']['user']
		command "php5 #{node['piwik']['home']}/misc/cron/archive.php -- url=http://#{node['piwik']['apache']['domain']}/ > /var/log/piwik-archive.log"
	end
end