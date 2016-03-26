# == Schema Information
#
# Table name: ticket_orders
#
#  id             :integer          not null, primary key
#  ticket_type_id :integer
#  order_id       :integer
#  quantity       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TicketOrder < ActiveRecord::Base
  belongs_to :ticket_type
  belongs_to :order

  validates_numericality_of :quantity, only_integer: true, greater_than: 0
end
