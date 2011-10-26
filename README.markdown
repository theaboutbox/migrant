Migrant
=======

Migrant is a tool to take your Vagrant boxes to the 'cloud'.

Migrant is designed to be a simple, focused tool to take boxes that are
working locally with Vagrant and deploy them remotely. Migrant reads
most configuration and provisioning information from Vagrant's 
configuration files and then applies the same approach to remote 'cloud'
servers.

Installation
------------

```
  $ gem install migrant-boxes
```

Or in a `Gemfile`:

```ruby
  gem 'migrant-boxes'
```

Examples
========

For single box configurations, the minimum that needs to be specified
are provider access credentials and the location of the SSH keys to use
to access the box.

Minimal AWS Configuration
-------------------------

This sets up a 'micro' sized aws box.

```ruby
Configuration.for('migrant') {
  provider {
    name       'aws'
    access_key ENV['AWS_ACCESS_KEY']
    secret_key ENV['AWS_SECRET_KEY']
  }
  ssh {
    public_key '~/.ssh/id_rsa.pub'
    private_key '~/.ssh/id_rsa'
  }
}
```

Minimal Rackspace Configuration
-------------------------------

This sets up an instance with 256MB ram

```ruby
Configuration.for('migrant') {
  provider {
    name      'rackspace'
    user_name ENV['RACKSPACE_ACCESS_KEY']
    api_key   ENV['AWS_SECRET_KEY']
  }
  ssh {
    public_key '~/.ssh/id_rsa.pub'
    private_key '~/.ssh/id_rsa'
  }
}
```

This will create the smallest possible server instance and run the provisioners
that are defined in the Vagrantfile.  It will use your ssh keys to
access the box, and write some state information about instances to 
`config/migrant.yml`

Migrant is highly opinionated: it will use the latest LTS Ubuntu
release. It will also download and install Ruby 1.9 from source in
`/usr/local`.

Customizing AWS instances
-------------------------

It's also possible to specify the size of the box and the AMI to use
when provisioning. Keep in mind that as of right now all the
bootstrapping and provisioning code is designed to work with recent
flavors of Ubuntu.

```ruby

Configuration.for('migrant') {
  provider {
    name       'aws'
    access_key ENV['AWS_ACCESS_KEY']
    secret_key ENV['AWS_SECRET_KEY']
    ip_address '1.2.3.4'             # <-- Elastic IP address
    flavor     'c1.medium'           # <-- Any instance size
    image_id   'ami-81b275e8'        # <-- AMI ID to use (Lucid 32-bit)
  }
  ssh {
    public_key '~/.ssh/id_rsa.pub'
    private_key '~/.ssh/id_rsa'
  }
}
```
Customizing Rackspace Instances
-------------------------------

It's also possible to customize the server size with Rackspace.

```ruby
Configuration.for('migrant') {
  provider {
    name      'rackspace'
    user_name ENV['RACKSPACE_ACCESS_KEY']
    api_key   ENV['AWS_SECRET_KEY']
    flavor_id 3 # <-- 1GB Server
  }
  ssh {
    public_key '~/.ssh/id_rsa.pub'
    private_key '~/.ssh/id_rsa'
  }
}
```

Configuring Multiple Environments
---------------------------------

Most deployments have at least a staging and a production environment.
Migrant supports an arbitrary number of named environments.

```ruby
Configuration.for('migrant') {
  provider {
    name      'rackspace'
    user_name ENV['RACKSPACE_ACCESS_KEY']
    api_key   ENV['AWS_SECRET_KEY']
  }
  ssh {
    public_key '~/.ssh/id_rsa.pub'
    private_key '~/.ssh/id_rsa'
  }

  # Production environment settings. Defaults are inherited from above
  production {
    provider {
      flavor_id 3  # <-- 1GB Server
    }
  }

  # Staging environment settings. Defaults are inherited from above
  staging {
    provider {
      flavor_id 1  # <-- 256MB Server
    }
  }
}
```

Usage
=====
```
  $ gem install migrant
  $ migrant init
  $ migrant up
```

For a box in a particular 'environment':

```
  $ migrant production up
  $ migrant staging up
  $ migrant staging destroy
```

Gotchas
=======

* Bootstrapping and provisioning only tested on Ubuntu 'Lucid Lynx'
* Chef-Solo provisioner the only one implemented
* Currently does not support multi-vm configurations. Eventually would
  be nice to support load-balanced configurations, and have some ability
  to start or stop any instances necessary to implement that
  configuration (like PoolParty).
