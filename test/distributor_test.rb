require_relative "test_helper"
require_relative "../lib/distributor"

=begin
  The distributor class is used to manipulate numbers in an array but keep the
  same total value. The aggregate change is applied to the final element.

  out = Distributor.new([ 1.1, 3.2, 4.5 ]).run do |num|
    num.to_i
  end

  out #=> [1, 3, 5]
=end

class DistributorTest < ::Test

  def test_it_doesnt_blow_up_with_an_empty_array
    result = Distributor.new([]).run{}
    assert_result_matches(result, [])
  end

  def test_it_applies_the_leftover_to_the_last_element
    d = Distributor.new([ 1.1, 3.2, 4.5 ])

    result = d.run do |item|
      item.to_i
    end

    assert_result_matches(result, [1, 3, 4.8])
  end

  def test_it_handles_precision
    precision = 10 ** 3
    d = Distributor.new([ 1.2535, 3.2593, 2.1904 ])

    result = d.run do |item|
      (item * precision).truncate.to_f / precision
    end

    assert_result_matches(result, [ 1.253, 3.259, 2.1912 ])
  end

  def test_it_is_fine_with_changes_in_the_positive_direction
    d = Distributor.new([ 1.2, 3.5, 10])

    result = d.run do |item|
      item.ceil
    end

    assert_result_matches(result, [ 2, 4, 8.7] )
  end

  def test_it_is_fine_with_different_types
    d = Distributor.new([1.353, 3.53, BigDecimal(10.1436, 16), BigDecimal(20)])

    result = d.run do |item|
      BigDecimal(item, 16).round(3)
    end

    assert_result_matches(result, [ 1.353, 3.53, 10.144, 19.9996 ])
  end


  protected

  # all it's doing is sanitize the result and the expectation so they
  # can be evaluated together
  def assert_result_matches(result, expected)
    assert_equal expected.map(&:to_f), result.map(&:to_f)
  end


end
