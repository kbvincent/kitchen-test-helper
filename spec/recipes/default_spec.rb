require_relative '../spec_helper'

describe 'kitchen-test-helper::default' do
  context 'centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.6') do |node|
      end.converge(described_recipe)
    end

    it 'installs the activesupport gem' do
      expect(chef_run).to install_chef_gem('activesupport')
    end

    it 'creates the serverspec directory' do
      expect(chef_run).to create_directory('/tmp/serverspec/')
    end

    it 'writes a log' do
      expect(chef_run).to write_log('Dumping attributes to \'node.json\'')
    end

    it 'runs a ruby_block to dump_node_attributes' do
      expect(chef_run).to run_ruby_block('dump_node_attributes')
    end

    it 'creates a file with attributes' do
      expect(chef_run).to create_file('/tmp/serverspec/node.json').with(
        user: 'root',
        mode: '0400',
      )
    end
  end
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
      end.converge(described_recipe)
    end

    it 'installs the activesupport gem' do
      expect(chef_run).to install_chef_gem('activesupport')
    end

    it 'creates the serverspec directory' do
      expect(chef_run).to create_directory('C:\\windows\\temp\\serverspec\\')
    end

    it 'writes a log' do
      expect(chef_run).to write_log('Dumping attributes to \'node.json\'')
    end

    it 'runs a ruby_block to dump_node_attributes' do
      expect(chef_run).to run_ruby_block('dump_node_attributes')
    end

    it 'creates a file with attributes' do
      expect(chef_run).to create_file('C:\\windows\\temp\\serverspec\\node.json')
    end
  end
end

