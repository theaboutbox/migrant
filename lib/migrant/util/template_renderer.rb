require 'vagrant'

module Migrant
  module Util
    class TemplateRenderer < ::Vagrant::Util::TemplateRenderer
      # Returns the full path to the template, taking into accoun the gem directory
      # and adding the `.erb` extension to the end.
      #
      # @return [String]
      def full_template_path
        Migrant.source_root.join('templates', "#{template}.erb").to_s.squeeze("/")
      end    
    end
  end
end
