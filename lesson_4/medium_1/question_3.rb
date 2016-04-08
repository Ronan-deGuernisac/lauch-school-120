# question_3.rb

# Using attr_accessor allows quantity to be changed directly without using the update_quantity
# method. E.g. you could just call <instance>.quantity = new_value
# You are effectively altering the public interfaces of the class

class InvoiceEntry
  attr_reader :quantity, :product_name # using attr_accessor here alters the public interfaces
                                       # of the class
  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end
