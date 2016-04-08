# question_1.rb

# Ben is correct since his method is only reading the balance instance variable and it is 
# accessible under attr_reader

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

acc = BankAccount.new(1000)

acc.positive_balance? # => true
