require 'spec_helper'
require 'tempfile'

describe Migrant::Boxes do
  before do
    tmpfile = Tempfile.new(['boxes','.yml'])
    @path = tmpfile.path
    tmpfile.close
    tmpfile.unlink
  end

  after do
    File.unlink @path
  end

  def box_yaml
      YAML.load(File.read @path)
  end
  
  def boxes
      Migrant::Boxes.new(@path).load
  end

  context 'default environment' do
    context 'writing box information' do
      before do
        b = Migrant::Boxes.new(@path)
        b.add(nil,'aws','i-abc123')
        b.save
      end

      it 'writes a valid yaml file' do
        expect { box_yaml }.not_to raise_error
      end

      it 'writes the provider' do
        boxes[nil].provider.should == 'aws'
      end

      it 'writes the instance id' do
        boxes[nil].id.should == 'i-abc123'
      end

    end
  end
  context 'named environment' do
    before do
      b = Migrant::Boxes.new(@path)
      b.add(nil,'aws','i-abc123')
      b.add('testing','rackspace','123456')
      b.save
    end
    
    it 'writes the provider' do
      boxes['testing'].provider.should == 'rackspace'
    end

    it 'writes an instance id' do
      boxes['testing'].id.should == '123456'
    end
  end
end
