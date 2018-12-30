require 'airrecord'
require 'minitest/autorun'
require 'dotenv/load'

class Tea < Airrecord::Table
  self.api_key = ENV.fetch('AIRTABLE_API_KEY')
  self.base_key = "app5gmfuvQnN1bIyR"
  self.table_name = "Tea"
end

class Brew < Airrecord::Table
  self.base_key = "app1"
  self.table_name = "Brews"

  belongs_to :tea, class: "Tea", column: "Tea"

  def self.hot
    records(filter: "{Temperature} > 90")
  end

  def done_brewing?
    Time.parse(self["Created At"]) + self["Duration"] > Time.now
  end
end

class IntegrationTest < Minitest::Test
  def test_sorting_by_multiple_fields
    records = Tea.order({ 'Name' => 'asc', 'Type' => 'desc' }).to_a

    assert_equal records.first['Name'], '2005 Jingmai Mini Brick'
    assert_equal records.last['Name'], 'Yutaka Midori Fukamushi'
  end

  def test_sorting_by_one_field
    records = Tea.order('Type' => 'desc').to_a

    assert_equal records.first['Type'], 'Yellow'
    assert_nil records.last['Type']
  end

  def test_find_by
    record = Tea.find_by("Name" => "Sencha Maroyaka")

    assert_equal record['Name'], 'Sencha Maroyaka'
  end

  def test_find_by_with_bang
    Tea.find_by!('Name' => 'no such tea')
  rescue Airrecord::Error => ex
    msg = 'HTTP 404: RECORD_NOT_FOUND: No record matches those conditions'
  ensure
    assert_equal msg, ex.message
  end


  def test_where
    records = Tea.where("Type" => "Black")

    assert_equal Airrecord::Relation, records.class
    assert_equal 9, records.count
  end

  def test_chainable_filters
    records = Tea.where("Type" => "Black").order("Name" => "asc").limit(5)

    assert_equal 5, records.count
    assert_equal '2013 Summer Vulvet Rubies', records.first['Name']
  end
end
