Migrant
=======

Migrant is a tool to take your Vagrant boxes to the 'cloud'.

Installation
------------

gem install migrant

Example
-------

Minimal Single server configurations

  Migrant::Config.run do |config|
    config.provider = :aws
    config.aws.access_key = 'access_key'
    config.aws.secret_key = 'secret_key'
  end

Or for rackspace

  Migrant::Config.run do |config|
    config.provider = :rackspace
    config.rackspace.api_key = 'api_key'
  end

This will create the smallest possible server instance and run the provisioners
that are defined in the Vagrantfile.  It will create ssh keys on 
`config/ssh_keys` and write some state information about instances to 
`config/migrant.yml`

Migrant is highly opinionated: it will use the latest LTS Ubuntu
release. It will also download and install Ruby 1.9 from source in
/usr/local.

Usage
-----

  $ gem install migrant
  $ migrant init
  $ migrant up

