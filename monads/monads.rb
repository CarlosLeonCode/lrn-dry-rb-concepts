require 'dry/monads'

class ResultCalculator
  include Dry::Monads[:result, :do]

  def calculate(input)
    value = Integer(input)

    value = yield add_3(value)
    value = yield mult_2(value)

    Success(value)
  end

  def add_3(value)
    if value > 1
      Success(value + 3)
    else
      Failure("value was less than 1")
    end
  end

  def mult_2(value)
    if value % 2 == 0
      Success(value * 2)
    else
      Failure("value was not even")
    end
  end
end


c = ResultCalculator.new
puts c.calculate(3)
puts c.calculate(0)
puts c.calculate(2)
