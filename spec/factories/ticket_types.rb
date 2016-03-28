# == Schema Information
#
# Table name: ticket_types
#
#  id               :integer          not null, primary key
#  event_id         :integer
#  price            :integer
#  name             :string
#  max_quantity     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  minimum_quantity :integer          default(1)
#

FactoryGirl.define do
  factory :ticket1, class: TicketType do
    name 'vip'
    price 100000
    minimum_quantity 2
    max_quantity 20
  end

  factory :ticket2, class: TicketType do
    name 'normal'
    price 200000
    minimum_quantity 1
    max_quantity 20
  end

  factory :ticket3, class: TicketType do
    name 'super'
    price 300000
    minimum_quantity 3
    max_quantity 20
  end
end
