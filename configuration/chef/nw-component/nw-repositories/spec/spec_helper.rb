require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! do
  # Don't test included cookbooks
  add_filter %r{..\/yum}
end
