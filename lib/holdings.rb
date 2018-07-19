class Holdings

  def self.compare(current_holdings, desired_holdings)

    #TODO: smarter logic here to compare holdings
    #      e.g. desired back to current
    current_holdings.each do |key, value|
      if found_holding = desired_holdings[key]
        if found_holding == value
          # do nothing
        else
          return false
        end
      else
        return false
      end
    end
    return true
  end  

  def self.buy(equity, qty)
    equity += qty
  end

  def self.sell(equity, qty)
    equity -= qty
  end

end