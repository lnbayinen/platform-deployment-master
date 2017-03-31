require 'chefspec'

ChefSpec::Coverage.start! do
  # Don't test included cookbooks
  add_filter %r{..\/nw-base}
end
