node.default['piwik']['databag'] = Chef::EncryptedDataBagItem.load("passwords", "piwik")

node.default['piwik']['home'] = node['piwik']['databag']['home']
node.default['piwik']['user'] = node['piwik']['databag']['user']
node.default['piwik']['group'] = node['piwik']['databag']['group']
node.default['piwik']['version'] = "1.12"
node.default['piwik']['download_url'] = "http://builds.piwik.org/piwik-#{node['piwik']['version']}.tar.gz"
node.default['piwik']['checksum'] = "b008dd452541af8051cdcf262a333937ba5c86af34e070932d378d256f03fba2"

node.default['piwik']['php-fpm']['enabled'] = true
node.default['piwik']['php-fpm']['socket'] = "/tmp/piwik.sock"

node.default['piwik']['apache']['install_vhost'] = false
node.default['piwik']['apache']['domain'] = nil # e.g. piwik.yourserver.tld

node.default['piwik']['cron']['enabled'] = true
node.default['piwik']['cron']['minute'] = "5"
node.default['piwik']['cron']['hour'] = "*"
node.default['piwik']['cron']['day'] = "*"
node.default['piwik']['cron']['month'] = "*"
node.default['piwik']['cron']['weekday'] = "*"

node.default['piwik']['database']['host'] = node['piwik']['databag']['database']['host']
node.default['piwik']['database']['username'] = node['piwik']['databag']['database']['username']
node.default['piwik']['database']['password'] = node['piwik']['databag']['database']['password']
node.default['piwik']['database']['dbname'] = node['piwik']['databag']['database']['dbname']
node.default['piwik']['database']['port'] = 3306