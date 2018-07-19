require_relative "test_helper"
require_relative "../lib/holdings"

class HoldingsTest < ::Test

  # Tests for holdings
    
  # Test 1 - if two sets of holdings are equal, no error is raised
  def test_two_equal_sets_of_holdings
    current_holdings = { a: 5.0, b: 2.4, c: 2.7, d: 1.9 }
    desired_holdings = { a: 5.0, b: 2.4, c: 2.7, d: 1.9 }    
    #byebug
    balanced_portfolio = Holdings.compare(current_holdings, desired_holdings)
    
    assert(true, balanced_portfolio)

  end

  def test_two_unequal_sets_of_holdings
    current_holdings = { a: 1.0, b: 2.0, c: 3.0, d: 4.0 }
    desired_holdings = { a: 1.0, b: 2.0, c: 3.5, d: 4.0 }
    #byebug
    balanced_portfolio = Holdings.compare(current_holdings, desired_holdings)
    
    assert_equal(false, balanced_portfolio)

  end

  #TODO: need more tests here for advanced comparisons

  def test_buying_increases_value
    #byebug
    current_holdings = { a: 1.0 }

    assert_equal(Holdings.buy(current_holdings[:a], 2.0), 3.0)
  end

  def test_selling_increases_value
    #byebug
    current_holdings = { a: 5.0 }

    assert_equal(Holdings.sell(current_holdings[:a], 2.0), 3.0)
  end

end