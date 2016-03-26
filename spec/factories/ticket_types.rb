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
    max_quantity 20
  end
end
