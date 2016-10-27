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
#  user_id      :integer
#  local_image  :string
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'attributes' do
    it { should belong_to(:venue) }
    it { should belong_to(:category) }
    it { should belong_to(:user) }
    it { should respond_to(:is_hot) }
    it { should respond_to(:is_published) }
    it { should respond_to(:local_image) }
    it { should respond_to(:local_image_url) }
    it { should respond_to(:remote_local_image_url) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should respond_to(:region_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:venue_id) }
    it { should validate_presence_of(:category_id) }
    it { should have_many(:ticket_types).dependent(:destroy) }
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
        event.start_at = Time.zone.local(3000, 7, 20)
        expect(event.upcoming?).to eq(true)
      end
    end

    describe '#related' do
      before(:each) do
        @events = DataSupport.create_events
      end

      it 'should return related events' do
        expect(@events[0].related.map { |e| e.name }).to match_array ['bbbbb']
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
        expect(upcoming).to eq %w(bbbbb abc)
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
