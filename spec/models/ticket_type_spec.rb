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

require 'rails_helper'

RSpec.describe TicketType, type: :model do
  it { should belong_to(:event) }
  it { should validate_presence_of(:event_id) }
  it { should validate_numericality_of(:max_quantity).only_integer }
  it { should validate_numericality_of(:max_quantity).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:price).only_integer }
  it { should validate_uniqueness_of(:price).scoped_to(:event_id) }
end
