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
    #byebug
    if @current_holdings.values.sum != @desired_holdings.values.sum
      raise "Inputs and Outputs must equate"
    end

    # iterate holdings and compare
    #unless Holdings.compare(@current_holdings, @desired_holdings)
    #  raise "Inputs and Outputs must equate"
    #end

  end

  def solve
    #[{ from: :a, to: :b, amount: BigDecimal.new(@current_holdings[:a])}]
    results = []

    cash = 0.0

    # sync all current holdings to desired values
    @current_holdings.each do |from_key, from_value|
      matched_holdings = @desired_holdings.select { |k,v| k == from_key && v == from_value }
      if matched_holdings.size == 0
        cash += from_value
        @current_holdings.delete(from_key)
        @desired_holdings.delete(from_key)
        if to_key = @desired_holdings.select {|k, v| v == from_value }.first
          results << {:from=>from_key, :to=>to_key[0], :amount=>BigDecimal.new(from_value)}
        end
      else
        matched_holdings.each do |matched_holding|
          #if holding[from_key] 
          if matched_holding[from_key] > from_value
            difference = matched_holding[from_key] - from_value
            cash -= difference
            @current_holding[from_key] += difference
          else
            difference = from_value - matched_holding[from_key]
            cash += difference
            @current_holding[from_key] += difference
          end
        end
      end
    end

    # purchase all remaining desired holdings
    @desired_holdings.each do |to_key, to_value|
      cash -= to_value
      @current_holdings[to_key] = to_value
      @desired_holdings.delete(to_key)
    end

    return results

  end # solve

end