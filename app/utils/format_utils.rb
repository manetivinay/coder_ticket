include ActionView::Helpers::NumberHelper

class FormatUtils
  def self.format_price(amount)
    number_to_currency(amount, precision: 0, separator: '.',
                       delimiter: '.', unit: '', format: "%n VND")
  end

  def self.string_to_date(value)
    datas = value.scan(/\w+/)
    Time.zone.local(
        datas[2].to_i,
        Date::MONTHNAMES.index(datas[1]),
        datas[0].to_i)
  end

  def self.date_to_string(value)
    "#{value.day} #{Date::MONTHNAMES[value.month]}, #{value.year}" if value
  end
end