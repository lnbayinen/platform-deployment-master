# Packages to be installed on any component
default['nw-base']['packages'] = [
  { 'name' => 'java-1.8.0-openjdk', 'version' => '1:1.8.0.101-3.b13.el7_2' },
  { 'name' => 'rsa-carlos', 'version' => '11.0.0.0' },
  { 'name' => 'rsa-collectd', 'version' => '11.0.0.0' },
  { 'name' => 'rsa-sms-runtime-rt', 'version' => '11.0.0.0' }
]
