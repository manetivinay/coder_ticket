# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  start_at     :datetime
#  end_at       :datetime
#  venue_id     :integer
#  image        :string
#  description  :text
#  category_id  :integer
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_hot       :boolean          default(FALSE)
#  is_published :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'attributes' do
    it { should belong_to(:venue) }
    it { should belong_to(:category) }
    it { should have_many(:ticket_types).dependent(:destroy) }
    it { should validate_presence_of(:venue) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:description) }
    it { should validate_uniqueness_of(:name).scoped_to([:venue_id, :start_at]) }
    it { should respond_to(:is_hot) }
    it { should respond_to(:is_published) }
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

  context 'scope' do
    before(:each) do
      DataSupport.create_events
    end

    describe '.upcoming' do
      it 'should return upcoming events' do
        upcoming = Event.upcoming.map { |event| event.name }
        expect(upcoming).to eq %w(abc bbbbb)
      end
    end

    describe '.search' do
      it 'should return upcoming events with search' do
        search = Event.search('a').map { |event| event.name }
        expect(search).to eq %w(abc)
      end
    end
  end
end
