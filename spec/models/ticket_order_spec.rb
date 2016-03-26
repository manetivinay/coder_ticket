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

require 'rails_helper'

RSpec.describe TicketOrder, type: :model do
  it { should belong_to(:order) }
  it { should belong_to(:ticket_type) }
  it { should validate_numericality_of(:quantity).only_integer }
  it { should validate_numericality_of(:quantity).is_greater_than(0) }
end
