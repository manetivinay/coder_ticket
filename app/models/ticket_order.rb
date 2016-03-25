class TicketOrder < ActiveRecord::Base
  belongs_to :ticket_type
  belongs_to :order

  validates_numericality_of :quantity, only_integer: true
end
