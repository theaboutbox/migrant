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
    def load
      @boxes = YAML.load(File.read(@path)) if File.exists?(@path)
      self
    end

    def initialize(path)
      @path = path
      @boxes = {}
      @boxes['file_version'] = Migrant::VERSION
      @boxes['boxes'] = Hash.new
      load
    end

    def save()
      File.open(@path,'w') do |f|
        f.write(YAML.dump(@boxes))
      end
    end

    def [](environment)
      environment = 'default' if environment.nil?
      @boxes['boxes'][environment]
    end

    def []=(environment,box)
      environment = 'default' if environment.nil?
      @boxes['boxes'][environment] = box
    end

    def add(environment,provider,id)
      environment = 'default' if environment.nil?
      box = Box.new(provider,id)
      self[environment] = box
      self
    end

    def remove(environment)
      environment = 'default' if environment.nil?
      @boxes['boxes'].delete(environment)
      self
    end
  end
end
