require 'spec_helper'

describe Migrant::Environment do
  before do
    Configuration.for('migrant') {
      provider {
        name      'rackspace'
        flavor_id 1
      }

      ssh {
        public_key 'test'
        private_key 'test'
      }

      staging {
        # Defaults
      }

      production {
        provider {
          flavor_id 2
        }
      }
    }

    @cfg = Configuration.for('migrant')
    @staging_env = Migrant::Environment.new('staging',@cfg)
    @production_env = Migrant::Environment.new('production',@cfg)
    @default_env = Migrant::Environment.new(nil,@cfg)
  end
 
  it "retrieves properties when there is no environment set" do
    @default_env.setting('provider.flavor_id').should == 1
  end
  it "retrieves configuration properties for the current environment" do
    @production_env.setting('provider.flavor_id').should == 2
  end
  it "defaults properties that do not exist in the current environment" do
    @staging_env.setting('provider.flavor_id').should == 1
  end
  it "provides a useful message for a non-existent environment" do
    expect {foobar_env = Migrant::Environment.new('foobar',@cfg)}.to raise_error
  end
end
