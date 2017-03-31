template '/etc/nginx/conf.d/nginx.conf' do
  source 'nw-ui.conf.erb'
  owner 'nginx'
  group 'nginx'
  mode '0644'
end
