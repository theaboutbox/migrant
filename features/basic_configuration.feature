Feature: Basic Configuration
  In order to use Migrant to provision boxes remotely
  I need to configure some minimal information

  Scenario: Basic AWS Configuration
    Given a Migrantfile with the body
      """
      Configuration.for('migrant') {
        provider {
          name       'aws'
          access_key 'my_access_key'
          secret_key 'my_secret_key'
        }
        ssh {
          public_key '~/.ssh/id_rsa.pub'
          private_key '~/.ssh/id_rsa'
        }
      }
      """
    Then the cloud should be "aws"
    And my AWS access key should be "my_access_key"
    And my AWS secret key should be "my_secret_key"
    And my ssh public key should reside at "~/.ssh/id_rsa.pub"
    And my ssh private key should reside at "~/.ssh/id_rsa"
    And my AWS instance ID should be "t1.micro"
    And my AWS AMI should be "Ubuntu Lucid Lynx" for the architecture "AMD64"

  Scenario: Basic Rackspace Configuration
    Given a Migrantfile with the body
      """
      Configuration.for('migrant') {
        provider {
          name      'rackspace'
          user_name 'my_user_name'
          api_key   'my_api_key'
        }
        ssh {
          public_key '~/.ssh/id_rsa.pub'
          private_key '~/.ssh/id_rsa'
        }
      }
      """
    Then the cloud should be "rackspace"
    And my rackspace username should be "my_user_name"
    And my rackspace api key should be "my_api_key"
    And my image should be "Ubuntu Lucid Lynx"
    And my flavor should be "256 MB Server"
