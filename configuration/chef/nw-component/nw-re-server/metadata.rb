name             'nw-re-server'
maintainer       'RSA Security, LLC'
maintainer_email 'support@rsa.com'
license          'Proprietary - All Rights Reserved'
description      'Installs/configures nw-re-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.1'
supports         'centos', '>= 7'
depends          'firewall', '~> 2.5.2'
depends          'nw-base', '>= 0.2.0'
depends          'systemd', '>= 2.1.3'
chef_version     '>= 12'
source_url       'file:///dev/null'
issues_url       'file:///dev/null'
