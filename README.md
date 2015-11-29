# kitchen-test-helper
This cookbook provides a suite of tools to assist with testing chef cookbooks when using kitchen-test and serverspec.

- Node attributes dumpped to .json file for access within serverspec tests.
- Fake databags created to simulate a managed chef environment returning databags.




## Node Attributes Dump

Including this cookbook will create a `.json` file with the contents of all of the current node's attributes.

### How to use

Include in Berksfile:
```
source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'kitchen-test-helper'
end

```

Add `kitchen-test-helper` to the top of the run list in the `.kitchen.yml` configuration:
```
---
driver:
  name: vagrant

provisioner:
  name: chef_zero

platforms:
  - name: centos-6.6

suites:
  - name: default
    run_list:
      - recipe[kitchen-test-helper]
      - recipe[<<<<>>>>>]
```

Use the following `spec_helper.rb` file when attempting to use node attributes within serverspec tests.
```
require 'serverspec'
require 'pathname'
require 'json'

if ENV['OS'] == 'Windows_NT'
  set :backend, :cmd
  # On Windows, set the target host's OS explicitely
  set :os, :family => 'windows'
  $node = ::JSON.parse(File.read('c:\windows\temp\serverspec\node.json'))
else
  set :backend, :exec
  $node = ::JSON.parse(File.read('/tmp/serverspec/node.json'))
end

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'
```

How to use the node's variables in serverspec tests:
```
describe file("#{$node['python']['prefix_dir']}/bin/python2.7") do
  it { should exist }
end

describe file("#{$node['nginx']['dir']}/www") do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by "#{$node['nginx']['user']}" }
  it { should be_grouped_into "#{$node['nginx']['group']}" }
end
```





## Databag Faker
Some cookbooks require databags to be created in order for the cookbook to correctly be ran.

This recipe will build a databag, place it in the correct local databag location, and allow future cookbooks to use the created databags as if they had been read from a chef server.
​
To use this recipe, include it in your Kitchen yml runlist, before any other recipes:
​```
---
driver:
  name: vagrant

provisioner:
  name: chef_zero

platforms:
  - name: centos-6.6

suites:
  - name: default
    run_list:
      - recipe[kitchen-test-helper]
      - recipe[<<<<>>>>>]
```

##### Creating Faked Databags
To add a databag, add fake_databags to the attributes in your 'kitchen.yml' following the example below.
This will create a databag item named `tuser.json` and will put it in the `users` databag.
​
```Ruby
---
driver:
  name: vagrant

provisioner:
  name: chef_zero

platforms:
  - name: centos-6.6

suites:
  - name: default
    run_list:
      - recipe[kitchen-test-helper]
      - recipe[<<<<>>>>>]
    attributes:
        fake_databags:
          - data_bag: 'users'
            content:
                id: 'tuser'
                user.first_name: 'test'
                user.last_name: 'user'
                user.email: 'test_user@test.com'
```

The resulting databag (`users/tuser`) would look like this:
```Json
{
    "id": "tuser",
    "user.first_name": "test",
    "user.last_name": "user",
    "user.email": "test_user@test.com"
}
```
​
##### Creating Faked Databags with Secure Content
Some recipes require an SSH key, or other secure information that we do not want committed to github.
​Following the same example as above, we will add a data_bag item to the fake_databags array, but this time we will include a key that has an environment variable setting it's value.

First we need to export the environment variable:
```Bash
export ENV_VARIABLE_NAME="{{VARIABLE CONTENT}}"
```

Example:
```Bash
export TEST_GIT_SSH_KEY="FakeKeyValueFakeKeyValue"
```


```Ruby
suites:
  - name: default
    run_list:
      - recipe[kitchen-test-helper]
    attributes:
      test: 'value'
      fake_databags:
        - data_bag: 'git-credentials'
          content:
            id: 'test'
            key: "<%= ENV['TEST_GIT_SSH_KEY'] %>"
            user.name: 'TestUser'
            user.email: 'testuser@gmail.com'
```

The resulting databag (`git-credentials/test`) would look like this:
```Json
{
    "id": "test",
    "key": "FakeKeyValueFakeKeyValue",
    "user.name": "TestUser",
    "user.email": "testuser@gmail.com"
}
```

##### Multiple Databags
To create multiple databags within the same kitchen.yml, follow this example:
This will create a databag named `test.json` within the `git-credentials` folder, as well as a databag named `test2.json` within the `aws-credentials` folder.

```Ruby
suites:
  - name: default
    run_list:
      - recipe[kitchen-test-helper]
    attributes:
      test: 'value'
      fake_databags:
        - data_bag: 'git-credentials'
          content:
              id: 'test'
              key: <%= ENV['TEST_GIT_SSH_KEY'] %>
              user.name: 'TestUser'
              user.email: 'testuser@gmail.com'
        - data_bag: 'aws-credentials'
          content:
              id: 'test'
              key: <%= ENV['TEST_AWS_KEY'] %>
              user.name: 'TestUser'
              user.email: 'testuser@gmail.com’
```



