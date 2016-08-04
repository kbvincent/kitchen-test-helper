#
# Cookbook Name:: kitchen-test-helper
# Recipe:: default
#
# All rights reserved - Do Not Redistribute

include_recipe 'kitchen-test-helper::node-attributes'

if Chef::Config[:local_mode]
  include_recipe 'kitchen-test-helper::data-bag-faker' unless node['fake_databags'].nil?
end
