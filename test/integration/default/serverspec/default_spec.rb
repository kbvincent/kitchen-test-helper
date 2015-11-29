require_relative 'spec_helper'
require 'json'

describe file("#{$node['kitchen-test-helper']['node_attributes_path']}") do
  it { should be_directory }
end

describe file("#{$node['kitchen-test-helper']['node_attributes_path']}node.json") do
  it { should be_file }
  it { should contain('"test": "value"') }
end

fake_databags = $node['fake_databags']

fake_databags.each do |data_bag|
  case $node['platform_family']
    when 'debian', 'rhel', 'fedora'
      data_bag_dir_path = '/tmp/kitchen/data_bags/'
      data_bag_path = "#{data_bag_dir_path}#{data_bag['data_bag']}/#{data_bag['content']['id']}.json"
    when 'windows'
      data_bag_dir_path = "#{Dir.home()}\\AppData\\Local\\Temp\\kitchen\\data_bags\\"
      data_bag_path = "#{data_bag_dir_path}#{data_bag['data_bag']}\\#{data_bag['content']['id']}.json"
    else
      Chef::Log.error("kitchen-test-helper is not supported on #{$node['platform_family']}")
  end

  describe file(data_bag_path) do
    it { should be_file }
    content = JSON.pretty_generate(data_bag['content'])
    its(:content) { should match content }
  end
end
