require_relative "../lib/holdings"

class Rebalance

  def initialize(current_holdings, desired_holdings)
    @current_holdings = current_holdings
    @desired_holdings = desired_holdings
  end

  def solution
    validate!
    solve
  end

  protected

  def validate!
    byebug
    #if @current_holdings != @desired_holdings
    #  raise 'Inputs and Outputs must equate'
    #end

    # iterate holdings and compare
    #unless Holdings.compare(@current_holdings, @desired_holdings)
    #  raise "Inputs and Outputs must equate"
    #end

  end

  def solve
    #byebug
    #[{ from: :a, to: :b, amount: BigDecimal.new(@current_holdings[:a])}]

    # iterate through the current holdings looking for mismatches
    @current_holdings.each do |key, value|

      # get the corresponding security from desired holdings to compare value
      if desired_holding_value = @desired_holdings[key]

        if desired_holding_value == value

        elsif desired_holding_value < value

        elsif desired_holding_value > value

        end

      end

    end

  end



end
