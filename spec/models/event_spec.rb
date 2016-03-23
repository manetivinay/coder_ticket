# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  start_at    :datetime
#  end_at      :datetime
#  venue_id    :integer
#  image       :string
#  description :text
#  category_id :integer
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should belong_to(:venue) }
  it { should belong_to(:category) }
  it { should have_many(:ticket_types) }
  it { should validate_presence_of(:venue) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:image) }
  it { should validate_presence_of(:description) }
  it { should validate_uniqueness_of(:name).scoped_to([:venue_id, :start_at]) }
end
