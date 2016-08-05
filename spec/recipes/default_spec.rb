require 'spec_helper'

describe 'kitchen-test-helper::default' do
  context 'centos-6.7' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.7') do |node|
        node.set['kitchen-test-helper']['show_node_output'] = false
      end.converge(described_recipe)
    end

    it 'creates the serverspec directory' do
      expect(chef_run).to create_directory('/tmp/serverspec/')
    end

    it 'writes a log' do
      expect(chef_run).to write_log('Dumping attributes to \'node.json\'')
    end

    it 'creates a node.json file' do
      expect(chef_run).to create_file('/tmp/serverspec/node.json').with(
        user: 'root',
        mode: '0400',
        sensitive: true
      )
    end

    it 'updates content of node.json' do
      expect(chef_run).to render_file('/tmp/serverspec/node.json').with_content(/\"node_attributes_path\": \"\/tmp\/serverspec\/\"/)
    end
  end
  context 'centos-7.1' do
    cached(:chef_run)do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        node.set['kitchen-test-helper']['show_node_output'] = true
      end.converge(described_recipe)
    end

    it 'creates the serverspec directory' do
      expect(chef_run).to create_directory('/tmp/serverspec/')
    end

    it 'writes a log' do
      expect(chef_run).to write_log('Dumping attributes to \'node.json\'')
    end

    it 'creates a node.json file' do
      expect(chef_run).to create_file('/tmp/serverspec/node.json').with(
        user: 'root',
        mode: '0400',
        sensitive: false
      )
    end
    it 'updates content of node.json' do
      expect(chef_run).to render_file('/tmp/serverspec/node.json').with_content(/\"node_attributes_path\": \"\/tmp\/serverspec\/\"/)
    end
  end
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.set['kitchen-test-helper']['show_node_output'] = true
      end.converge(described_recipe)
    end

    it 'creates the serverspec directory' do
      expect(chef_run).to create_directory('C:\\windows\\temp\\serverspec\\')
    end

    it 'writes a log' do
      expect(chef_run).to write_log('Dumping attributes to \'node.json\'')
    end

    it 'creates a node.json file' do
      expect(chef_run).to create_file('C:\\windows\\temp\\serverspec\\node.json').with(
        sensitive: false
      )
    end
    it 'updates content of node.json' do
      expect(chef_run).to render_file('C:\\windows\\temp\\serverspec\\node.json').with_content(/\"node_attributes_path\": \"C:\\\\windows\\\\temp\\\\serverspec\\\\\"/)
    end
  end
end
