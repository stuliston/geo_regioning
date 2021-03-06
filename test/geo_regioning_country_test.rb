require File.dirname(__FILE__) + '/test_helper'

class GeoRegioningCountryTest < Test::Unit::TestCase
  load_schema

  def test_country_geo_coding
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    assert_not_nil country.geo_latitude
    country.destroy
  end

  def test_country_level1_meta_finders
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    level1 = GeoRegioning::Level.create(:country => country, :long_name => 'Victoria', :short_code => 'VIC')
    level2 = GeoRegioning::Level.create(:country => country, :long_name => 'Casey', :parent => level1)
    level3 = GeoRegioning::Level.create(:country => country, :long_name => 'Berwick', :parent => level2)

    assert_equal 1, country.states.count
    assert_equal level1, country.states.first
    country.destroy
    level1.destroy
    level2.destroy
    level3.destroy
  end

  def test_country_level2_meta_finders
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    level1 = GeoRegioning::Level.create(:depth => 1, :country => country, :long_name => 'Victoria', :short_code => 'VIC')
    level2 = GeoRegioning::Level.create(:depth => 2, :country => country, :long_name => 'Casey', :parent => level1)
    level3 = GeoRegioning::Level.create(:depth => 3, :country => country, :long_name => 'Berwick', :parent => level2)

    assert_equal 1, country.cities.count
    assert_equal level2, country.cities.first
    country.destroy
    level1.destroy
    level2.destroy
    level3.destroy
  end

  def test_country_level3_meta_finders
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    level1 = GeoRegioning::Level.create(:depth => 1, :country => country, :long_name => 'Victoria', :short_code => 'VIC')
    level2 = GeoRegioning::Level.create(:depth => 2, :country => country, :long_name => 'Casey', :parent => level1)
    level3 = GeoRegioning::Level.create(:depth => 3, :country => country, :long_name => 'Berwick', :parent => level2)

    assert_equal 1, country.suburbs.count
    assert_equal level3, country.suburbs.first
    country.destroy
    level1.destroy
    level2.destroy
    level3.destroy
  end

  def test_level_to_s
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    level1 = GeoRegioning::Level.create(:depth => 1, :country => country, :long_name => 'Victoria', :short_code => 'VIC')
    level2 = GeoRegioning::Level.create(:depth => 2, :country => country, :long_name => 'Casey', :parent => level1)
    level3 = GeoRegioning::Level.create(:depth => 3, :country => country, :long_name => 'Berwick', :parent => level2)

    assert_equal "Berwick, Casey", level3.to_s
  end

  def test_level_address
    country = GeoRegioning::Country.create(:iso_3166 => 'AU', :name => 'Australia' )
    level1 = GeoRegioning::Level.create(:depth => 1, :country => country, :long_name => 'Victoria', :short_code => 'VIC')
    level2 = GeoRegioning::Level.create(:depth => 2, :country => country, :long_name => 'Casey', :parent => level1)
    level3 = GeoRegioning::Level.create(:depth => 3, :country => country, :long_name => 'Berwick', :parent => level2)

    assert_equal "Berwick, Vic", level3.address(:geocode)
    assert_equal "Berwick, Vic", level3.address
  end


end