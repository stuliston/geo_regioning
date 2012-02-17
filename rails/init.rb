require 'awesome_nested_set'

ActiveRecord::Base.class_eval do
  include CollectiveIdea::Acts::NestedSet
end

if defined?(ActionView)
  require 'awesome_nested_set/helper'
  ActionView::Base.class_eval do
    include CollectiveIdea::Acts::NestedSet::Helper
  end
end

require 'active_support'
require 'geo_regioning'

#Load the config
if File.exists?(File.join(Rails.root, 'config', 'geo_regioning.yml'))
  GeoRegioning::config = YAML.load_file(File.join(Rails.root, 'config', 'geo_regioning.yml'))
else
  GeoRegioning::config = YAML.load_file(File.join(Rails.root, 'vendor', 'plugins','geo_regioning', 'lib', 'config', 'geo_regioning.yml'))
end