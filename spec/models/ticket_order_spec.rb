require 'rails_helper'

RSpec.describe TicketOrder, type: :model do
  it { should belong_to(:order) }
  it { should belong_to(:ticket_type) }
  it { should validate_numericality_of(:quantity).only_integer }
end
