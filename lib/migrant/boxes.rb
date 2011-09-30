module Migrant
  # Represents a box managed by Migrant. We save this object in YAML format
  # so that subsequent runs of Migrant can find them.
  class Box
    attr_accessor :provider
    attr_accessor :id
    attr_accessor :name

    def initialize(box_provider=nil,box_id=nil,box_name=nil)
      @id = box_id
      @provider = box_provider
      @name = box_name
    end
  end

  # Loads and persists information about the boxes managed by this
  # migrant configuration
  class Boxes
    # Returns an Boxes instance
    def self.load(path)
      boxes = []
      boxes = YAML.load(File.read(path)) if File.exists?(path)
      Boxes.new(path,boxes)
    end

    def initialize(path,boxes)
      @path = path
      @boxes = boxes
    end

    def save()
      File.open(@path,'w') do |f|
        f.write(YAML.dump(@boxes))
      end
    end

    def first
      @boxes[0]
    end

    def [](index)
      @boxes[index]
    end

    def add(provider,name,id)
      box = Box.new(provider,name,id)
      @boxes << box
    end
  end
end
