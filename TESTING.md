# kitchen-test-helper Testing

Commands to run test suites:  
`chef exec rake ec2` - Runs RuboCop Style Tests, followed by ChefSpec Tests, followed by kitchen-ec2 serverspec tests.  
`chef exec rake test` - Runs RuboCop Style Tests, followed by ChefSpec Tests.  

`kitchen list all` - View list of local vagrant kitchen-test runs available.  
`kitchen verify` - Verify each local vagrant kitchen-test run available in order.  
`kitchen verify {instance_name}` - Verify {instance_name} using a local vagrant box.  

## Kitchen Testing
The following environment varibale will need to be exported before local kitchen testing will work:  
ENV['TEST_GIT_SSH_KEY']  

**Note: this can be set to a fake value like "FakeKeyFakeKey"**

## Kitchen-EC2 Testing

The following variables will need to be exported before ec2 testing will work:  

ENV['AWS_SSH_KEY']  
ENV['AWS_SECURITY_GROUPS']  
ENV['AWS_REGION']  
ENV['AWS_AVAILABILITY_ZONE']  
ENV['AWS_SUBNET']  
ENV['AWS_OWNER_TAG']  
ENV['SSH_KEY_PATH']  
ENV['AWS_SSH_KEY']  

####### For Centos Testing  
ENV['AWS_CENTOS_AMI_ID']  
ENV['LINUX_INSTANCE_SIZE']  
ENV['LINUX_USER_DATA_PATH']  
ENV['AWS_CENTOS_USERNAME']  

####### For Windows Testing  
ENV['AWS_WINDOWS2012R2_AMI_ID']  
ENV['WINDOWS_INSTANCE_SIZE']  
ENV['WINDOWS_USER_DATA_PATH']  

####### For Testing Purposes
ENV['TEST_GIT_SSH_KEY']
