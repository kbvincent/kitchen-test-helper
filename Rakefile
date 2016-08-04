gem 'test-kitchen', '1.10.2'
gem 'rubocop', '= 0.39.0'
gem 'foodcritic', '= 6.3.0'
gem 'serverspec', '= 2.36.0'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen/cli'

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
    ENV['KITCHEN_YAML'] = './.kitchen.ec2.yml'
    Kitchen::CLI.new([], concurrency: 5, destroy: 'always').test
  end
  task :ec2_singlethread do
    ENV['KITCHEN_YAML'] = './.kitchen.ec2.yml'
    Kitchen::CLI.new([], destroy: 'always').test
  end
end

# Default
task default: ['style', 'spec', 'integration:vagrant']
task ec2: ['style', 'spec', 'integration:ec2']
task ec2_singlethread: ['style', 'spec', 'integration:ec2_singlethread']
task test: ['style', 'spec']
