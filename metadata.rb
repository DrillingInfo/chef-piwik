maintainer       "Achim Rosenhagen"
maintainer_email "a.rosenhagen@ffuenf.de"
license          "Apache 2.0"
description      "installs/configures piwik"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

%w{ ubuntu debian }.each do |os|
	supports os
end

%w{ mysql database php apache2 }.each do |ressource|
	depends ressource
end

recipe "piwik::default", "installs/configures piwik"
