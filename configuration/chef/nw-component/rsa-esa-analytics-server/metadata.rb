name             'rsa-esa-analytics-server'
maintainer       'RSA Security, LLC'
maintainer_email 'support@rsa.com'
license          'Proprietary - All Rights Reserved'
description      'Installs/configures rsa-esa-analytics-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
supports         'centos', '>= 7'
depends          'firewall', '~> 2.5.2'
depends          'nw-base', '>= 0.2.0'
depends          'systemd', '>= 2.1.3'
depends          'nw-mongo', '>= 0.1.0'
chef_version     '>= 12'
source_url       'file:///dev/null'
issues_url       'file:///dev/null'
