require 'airrecord'
require 'minitest/autorun'

class Tea < Airrecord::Table
  self.api_key = raise(StandardError, 'Please enter an API key')
  self.base_key = "app5gmfuvQnN1bIyR"
  self.table_name = "Tea"
end

class IntegrationTest < Minitest::Test
  def test_sorting_by_multiple_fields
    Tea.records(sort: { 'Name' => 'asc', 'Type' => 'desc' }).tap do |res|
      assert_equal res.first['Name'], '2005 Jingmai Mini Brick'
      assert_equal res.last['Name'], 'Yutaka Midori Fukamushi'
    end
  end

  def test_sorting_by_one_field
    Tea.all(sort: { 'Type' => 'desc' }).tap do |res|
      assert_equal res.first['Type'], 'Yellow'
      assert_nil res.last['Type']
    end
  end
end
