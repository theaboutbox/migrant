require 'tempfile'
require 'configuration'
require 'pry'
require 'migrant'

Given /^a Migrantfile with the body$/ do |migrantfile_body|
  tmpfile = Tempfile.open('migrant-config') do |f|
    f.write migrantfile_body
    f
  end
  Kernel.load(tmpfile.path)
  @config = Configuration.for('migrant')
  @environment = Migrant::Environment.new(nil,@config)
end

Then /^the cloud should be "([^"]*)"$/ do |cloud_provider_name|
  # Make sure the environment is set up the right way
  @environment.cloud.class.should == Migrant::Clouds::Base.registered(cloud_provider_name)
end

Then /^my AWS access key should be "([^"]*)"$/ do |arg1|
  @config.provider.access_key.should == arg1
end

Then /^my AWS secret key should be "([^"]*)"$/ do |arg1|
  @config.provider.secret_key.should == arg1
end

Then /^my ssh public key should reside at "([^"]*)"$/ do |arg1|
  @config.ssh.public_key.should == arg1
end

Then /^my ssh private key should reside at "([^"]*)"$/ do |arg1|
  @config.ssh.private_key.should == arg1
end

Then /^my AWS instance ID should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^my AWS AMI should be "([^"]*)" for the architecture "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then /^my rackspace username should be "([^"]*)"$/ do |arg1|
  @config.provider.user_name.should == arg1
end

Then /^my rackspace api key should be "([^"]*)"$/ do |arg1|
  @config.provider.api_key.should == arg1
end

Then /^my image should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^my flavor should be "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

