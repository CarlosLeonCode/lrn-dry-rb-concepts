require "dry/transaction"

class Operation
  include Dry::Transaction
  include Dry::Monads

  tee :timer
  step :validate
  step :log
  map :merge
  step :persist
  step :build_phrase
  try :validate_phrase, catch: StandardError
  check :result

  def timer(input)
    counter = 1
    loop do 
      sleep 1
      puts counter
      counter += 1
      break if counter == 3
    end
  end

  def validate(input)
    puts '#validate'
    Success(input)
  end

  def log(input)
    puts '#logs'
    Success(input)
  end

  def merge(input)
    puts '#merge'
    input[:word] = :hi
    input
  end

  def persist(input)
    puts '#persist'
    if input.key? :word
      Success(input)
    else
      Failure(input)
    end
  end

  def build_phrase(input)
    puts '#build_phrase'

    input[:phrase] = "#{input[:word]} #{input[:name]}, you are #{input[:age]}"
    Success(input)
  end

  def validate_phrase(input)
    puts '#validate_phrase'

    expected_phrs = 'hi carlos, you are 12'
    
    if input[:phrase] == expected_phrs
      Success(input)
    else
      Failure(raise StandardError)
    end
  end

  def result(input)
    puts input
  end
end

Operation.new.call({name: 'carlos', age: 12})