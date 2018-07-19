require "bigdecimal"

class Distributor

  def initialize(source)
    @source = source
  end

  def run(&block)
    out = []

    @source.each_with_index do |item, idx|
      val = yield item
      out << val
    end

    out
  end

end
