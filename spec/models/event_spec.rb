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
  context 'attributes' do
    it { should belong_to(:venue) }
    it { should belong_to(:category) }
    it { should have_many(:ticket_types) }
    it { should validate_presence_of(:venue) }
    it { should validate_presence_of(:category) }
    it {  should validate_presence_of(:start_at) }
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name).scoped_to([:venue_id, :start_at]) }
  end

  context 'instance methods' do
    let(:event) { Event.new }

    describe '#upcoming?' do
      it 'should return false' do
        event.start_at = Time.zone.local(2015, 7, 20)
        expect(event.upcoming?).to eq(false)
      end

      it 'should return true' do
        event.start_at = Time.zone.local(2016, 7, 20)
        expect(event.upcoming?).to eq(true)
      end
    end
  end
end
