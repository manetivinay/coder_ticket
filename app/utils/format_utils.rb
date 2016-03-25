include ActionView::Helpers::NumberHelper

class FormatUtils
  def self.format_price(amount)
    number_to_currency(amount, precision: 0, separator: '.',
                       delimiter: '.', unit: '', format: "%n VND")
  end
end