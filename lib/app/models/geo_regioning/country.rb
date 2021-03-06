class GeoRegioning::Country < GeoRegioning::Base
  set_table_name 'geo_regioning_countries'
  
  has_many :children, :class_name => 'GeoRegioning::Level'
  has_many :postcodes, :dependent => :destroy, :class_name => 'GeoRegioning::Postcode'

  before_validation :upcase_iso_3166

  validates_presence_of :iso_3166
  validates_uniqueness_of :iso_3166

  @level_name_depth_map = {}

  def to_s(display = :display)
    address(:display)
  end

  def address(display = :geocode)
    unless GeoRegioning.config['country_definitions'][self.iso_3166]["exclude_from_#{display.to_s}"]
      value_method = GeoRegioning.config['country_definitions'][self.iso_3166]["#{display.to_s}_value"] || "code"
      self.send(value_method)
    end
  end

  def code
    iso_3166
  end

  def toplevel_depth
    @toplevel_depth ||= GeoRegioning.config['country_definitions'][self.iso_3166]['toplevel_depth'] rescue 1
  end

  def level_name_depth_map
    @level_name_depth_map if @level_name_depth_map
    levels_hash = {}
    GeoRegioning.config['country_definitions'][self.iso_3166].keys.select{|k| k.to_s.to_i == k}.map{|key| levels_hash[GeoRegioning.config['country_definitions'][self.iso_3166][key]['name']] = key}
    @level_name_depth_map = levels_hash
  end

  private
  def method_missing(method, *args, &block)
    #AR lazy loads the accessor methods so punt to super if we ever make it here
    if self.attributes.keys.include?(method.to_s)
      super
    elsif level_name_depth_map.keys.include?(method.to_s.singularize)
      self.children.of_depth(level_name_depth_map[method.to_s.singularize])
    else
      super
    end
  end

  def upcase_iso_3166
    self.iso_3166 = self.iso_3166.upcase
  end
  
end

