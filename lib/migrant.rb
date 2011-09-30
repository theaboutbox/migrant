module Migrant
  autoload :CLI,            'migrant/cli'
  autoload :Config,         'migrant/config'
  autoload :Environment,    'migrant/environment'
  autoload :UI,             'migrant/ui'
  autoload :Boxes,          'migrant/boxes'
  autoload :Util,           'migrant/util'

  def self.source_root
    @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
end
require 'migrant/clouds'
require 'migrant/provisioners'
require 'migrant/bootstrappers'
