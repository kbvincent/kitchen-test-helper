Chef::Log.warn('********* Creating fake Data Bags for testing purposes *********')
require 'chef/data_bag'

fake_databags = node['fake_databags']

fake_databags.each do |data_bag|
  unless Chef::DataBag.list.key?(data_bag['data_bag'])
    new_databag = Chef::DataBag.new
    new_databag.name(data_bag['data_bag'])
    new_databag.save
  end

  data_bag_file = Chef::DataBagItem.new
  data_bag_file.data_bag(data_bag['data_bag'])
  data_bag_file.raw_data = data_bag['content']
  data_bag_file.save
end
