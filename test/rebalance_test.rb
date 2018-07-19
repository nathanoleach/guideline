require_relative "test_helper"
require_relative "../lib/rebalance"

=begin

When managing one's portfolio there is a desired portfolio allocation (breakdown of holdings).
This is commonly referred to as the target portfolio or target allocations.
When you invest in securities you purchase them using your target allocations. Over time,
the market fluctuates and the value of each part of your purchase also fluctuates. This is
called portfolio drift. Drift measures how far you are from  your target allocations. When
there's enough drift, a "rebalance" is executed. A rebalance is the sale of the securities
that have too much account value, and the purchase of securities that have too little.

An example:

Desired allocation: VIMAX: 50%, BANC: 50%
Day 0:
  - purchase $10 of VIMAX, purchase $10 of BANC
  - holdings: 50% VIMAX / 50% BANC

...

Day 30:
  - the market has fluctuated so that VIMAX now makes up 60% of your portfolio in value
  - your total market value is now > 100% of your original purchase value
  - holdings: 60% VIMAX / 40% BANC

Day 31:
  - a rebalance is conducted which sells some VIMAX and purchases some BANC
  - new holdings: 50% VIMAX / 50% BANC
  - the market value is still > 100% of your original purchase value

So, how do you build a Rebalancer?

=end

class RebalanceTest < ::Test

  def test_it_validates_the_input_values_equate_to_the_output_values
    current_holdings = { a: 30 }
    desired_holdings = { b: 24 }

    begin
      Rebalance.new(current_holdings, desired_holdings).solution
      refute true
    rescue Exception => e
      assert_equal e.message, "Inputs and Outputs must equate"
    end
  end

  def test_it_generates_exchanges_for_simple_cases
    current_holdings = { a: 24 }
    desired_holdings = { b: 24 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      { from: :a, to: :b, amount: BigDecimal(24) }
    ])
    assert_equal expected, exchanges
  end

  def test_it_generates_exchanges_for_more_complex_cases
    current_holdings = { a: 10, b: 20 }
    desired_holdings = { a: 20, b: 10 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      { from: :b, to: :a, amount: BigDecimal(10) }
    ])
    assert_equal expected, exchanges
  end

  def test_it_mcreates_exchanges_for_new_ids
    current_holdings = { a: 10, b: 10 }
    desired_holdings = { a: 8, b: 8, c: 4 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      { from: :a, to: :c, amount: BigDecimal(2) },
      { from: :b, to: :c, amount: BigDecimal(2) }
    ])

    assert_equal expected, exchanges
  end

  def test_it_handles_precision
    current_holdings = { a: 3.2, b: 2.1 }
    desired_holdings = { a: 5, b: 0.3 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      { from: :b, to: :a, amount: BigDecimal(1.8, 16) }
    ])

    assert_equal expected, exchanges
  end

  def test_it_handles_a_bunch_of_elements
    current_holdings = { a: 3.2, b: 2.1, c: 3.9, d: 2.8 }
    desired_holdings = { a: 5.0, b: 2.4, c: 2.7, d: 1.9 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      {from: :c, to: :a, amount: 1.2},
      {from: :d, to: :b, amount: 0.3},
      {from: :d, to: :a, amount: 0.6},
    ])

    assert_equal expected, exchanges
  end

  def test_it_works_multiple_times
    current_holdings = { a: 3.2, b: 2.1, c: 3.9, d: 2.8 }
    desired_holdings = { a: 5.0, b: 2.4, c: 2.7, d: 1.9 }

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)

    expected = sanitize_exchanges([
      {from: :c, to: :a, amount: 1.2},
      {from: :d, to: :b, amount: 0.3},
      {from: :d, to: :a, amount: 0.6},
    ])

    assert_equal expected, exchanges

    exchanges = Rebalance.new(current_holdings, desired_holdings).solution
    exchanges = sanitize_exchanges(exchanges)
    assert_equal expected, exchanges
  end

  # TEST HELPERS

  def sanitize_exchanges(exchanges)
    exchanges.sort_by{|e| "#{e[:from]}-#{e[:to]}" }
  end

end
