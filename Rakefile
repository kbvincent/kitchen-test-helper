require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      tags: ['~FC005']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
  task :ec2 do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.ec2.yml')
    config = Kitchen::Config.new(loader: @loader)
    threads = []
    config.instances.each do |instance|
      threads << Thread.new do
        instance.test(:always)
      end
    end
    threads.map(&:join)
  end
end

# Default
task default: ['style', 'spec', 'integration:vagrant']
task ec2: ['style', 'spec', 'integration:ec2']
task test: ['style', 'spec']
