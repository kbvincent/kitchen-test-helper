#
# Cookbook Name:: kitchen-test-helper
# Recipe:: default
#
# Copyright 2015, Gannett
#
# All rights reserved - Do Not Redistribute

include_recipe 'kitchen-test-helper::node-attributes'

unless Chef::Config[:solo]
  include_recipe 'kitchen-test-helper::data-bag-faker' unless node['fake_databags'].nil?
end
