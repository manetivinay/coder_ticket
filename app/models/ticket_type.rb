# == Schema Information
#
# Table name: ticket_types
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  price        :integer
#  name         :string
#  max_quantity :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class TicketType < ActiveRecord::Base
  belongs_to :event
  validates_presence_of :event_id
  validates_presence_of :name
  validates_numericality_of :max_quantity, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :price, only_integer: true
  validates_uniqueness_of :price, scope: :event_id
end
