cookbook_path '/opt/rsa/platform/nw-chef/cookbooks'
file_cache_path '/opt/rsa/platform/nw-chef/cache'
json_attribs '/opt/rsa/platform/nw-chef/node.json'
local_mode true
exit_status :enabled
ohai.plugin_path << '/opt/rsa/platform/nw-chef/ohai'
