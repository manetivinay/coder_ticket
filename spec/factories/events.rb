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

FactoryGirl.define do
  factory :event1, class: Event do
    start_at Time.zone.local(2016, 8, 20)
    end_at Time.zone.local(2016, 10, 20)
    image 'link'
    description 'desc'
    name 'abc'
  end

  factory :event2, class: Event do
    start_at Time.zone.local(2015, 8, 20)
    end_at Time.zone.local(2015, 10, 20)
    image 'link'
    description 'desc'
    name 'aba'
  end

  factory :event3, class: Event do
    start_at Time.zone.local(2016, 8, 20)
    end_at Time.zone.local(2016, 10, 20)
    image 'link'
    description 'desc'
    name 'bbbbb'
  end
end
