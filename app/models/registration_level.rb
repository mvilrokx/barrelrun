class RegistrationLevel < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  def name_price
    name + ' (' + number_to_currency(price) + ')'
  end
end
