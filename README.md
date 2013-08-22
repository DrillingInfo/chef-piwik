Description
===========

Installs and configures [piwik](http://www.piwik.org/)

Requirements
============

This cookbook requires the following cookbooks to be present and installed:

* php
* apache2
* mysql
* database

Platform
--------

* Debian, Ubuntu

Attributes
==========
* `node['piwik']['databag']` - (default: Chef::EncryptedDataBagItem.load("passwords", "piwik"))
* `node['piwik']['home']` - (default: node['piwik']['databag']['home'])
* `node['piwik']['user']` - (default: node['piwik']['databag']['user'])
* `node['piwik']['group']` - (default: node['piwik']['databag']['group'])
* `node['piwik']['version']` - (default: "1.12")
* `node['piwik']['download_url']` - (default: "http://builds.piwik.org/piwik-#{node['piwik']['version']}.tar.gz")
* `node['piwik']['checksum']` - (default: "b008dd452541af8051cdcf262a333937ba5c86af34e070932d378d256f03fba2")
* `node['piwik']['php-fpm']['enabled']` - use php-fpm in apache via mod_fastcgi (default: true)
* `node['piwik']['php-fpm']['socket']` - (default: "/tmp/piwik.sock")
* `node['piwik']['cron']['enabled']` - (default: true)
* `node['piwik']['cron']['minute']` - (default: "5")
* `node['piwik']['cron']['hour']` - (default: "*")
* `node['piwik']['cron']['day']` - (default: "*")
* `node['piwik']['cron']['month']` - (default: "*")
* `node['piwik']['cron']['weekday']` - (default: "*")
* `node['piwik']['apache']['install_vhost']` - install apache web_app (default: false)
* `node['piwik']['apache']['domain']` -  domain for server-wide piwik installation e.g. piwik.yourserver.tld (default: nil)
* `node['piwik']['database']['host']` - (default: node['piwik']['databag']['database']['host'])
* `node['piwik']['database']['username']` - (default: node['piwik']['databag']['database']['username'])
* `node['piwik']['database']['password']` - (default: node['piwik']['databag']['database']['password'])
* `node['piwik']['database']['dbname']` - (default: node['piwik']['databag']['database']['dbname'])
* `node['piwik']['database']['port']` - (default: 3306)

Templates
==========

`web_app-piwik.conf`
-----------------

Custom apache web_app template which includes directives for php-fpm fastcgi pool

Usage
=====

Simply include the recipe. Make sure you do not store passwords in plain-text! Use encrypted databags instead.
This cookbook only extracts the needed files and creates a database. Since piwik does not currently support a fully unattended installation you have to go through the webinstaller and remember your database credentials.

License and Author
==================

Author:: Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)

Copyright:: 2013, Achim Rosenhagen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
