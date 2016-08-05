directory node['kitchen-test-helper']['node_attributes_path'] do
  recursive true
end

log "Dumping attributes to 'node.json'"

output = @Chef::JSONCompat.to_json_pretty(node.to_hash)
file "#{node['kitchen-test-helper']['node_attributes_path']}node.json" do
  owner 'root' unless node['platform_family'] == 'windows'
  mode '0400' unless node['platform_family'] == 'windows'
  content output
  sensitive true unless node['kitchen-test-helper']['show_node_output']
end
