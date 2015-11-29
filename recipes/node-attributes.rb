chef_gem 'activesupport'

require 'pathname'
require 'active_support/core_ext/hash/deep_merge'
require 'json'

directory node['kitchen-test-helper']['node_attributes_path'] do
  recursive true
end

file "#{node['kitchen-test-helper']['node_attributes_path']}node.json" do
  owner 'root' unless node['platform_family'] == 'windows'
  mode '0400' unless node['platform_family'] == 'windows'
end

log "Dumping node attributes to 'node.json'"

ruby_block 'dump_node_attributes' do
  block do
    attrs = {}
    attrs = attrs.deep_merge(node.automatic_attrs) unless node.automatic_attrs.empty?
    attrs = attrs.deep_merge(node.default_attrs) unless node.default_attrs.empty?
    attrs = attrs.deep_merge(node.normal_attrs) unless node.normal_attrs.empty?
    attrs = attrs.deep_merge(node.override_attrs) unless node.override_attrs.empty?

    recipe_json = "{ \"run_list\": \[ "
    recipe_json << node.run_list.expand(node.chef_environment).recipes.map! { |k| "\"#{k}\"" }.join(',')
    recipe_json << " \] }"
    attrs = attrs.deep_merge(JSON.parse(recipe_json))

    File.open("#{node['kitchen-test-helper']['node_attributes_path']}node.json", 'w') { |file| file.write(JSON.pretty_generate(attrs)) }
  end
end
