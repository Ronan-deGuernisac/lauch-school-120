# question_2.rb

# The mistake in the code is that the quantity instance variable is not available within the 
# update_quantity method. To fix this code we can prepent the quantity variable in the 
# update quanity method with an @
# Note: another option would be to set attr_accessor or attr_writer for quantity and use
# self.quantity in the method

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    # quantity = updated_count if updated_count >= 0 # orignal code
    @quantity = updated_count if updated_count >= 0 # fixed code
  end 
end

cart = InvoiceEntry.new('widget', 10)

p cart.quantity # => 10

cart.update_quantity(2)

p cart.quantity # => 2
