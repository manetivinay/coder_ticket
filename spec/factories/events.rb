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

FactoryGirl.define do
  factory :event1, class: Event do
    start_at Time.zone.local(3000, 8, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    description 'desc'
    name 'abc'
    is_published true
  end

  factory :event2, class: Event do
    start_at Time.zone.local(2016, 8, 20)
    end_at Time.zone.local(2016, 9, 20)
    image 'link'
    description 'desc'
    name 'aba'
    is_published true
  end

  factory :event3, class: Event do
    start_at Time.zone.local(3000, 8, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    description 'desc'
    name 'bbbbb'
    is_published true
  end

  factory :event4, class: Event do
    start_at Time.zone.local(2016, 8, 20)
    end_at Time.zone.local(2016, 10, 20)
    image 'link'
    description 'desc'
    name 'ccccc'
    is_published true
  end

  factory :valid_event, class: Event do
    start_at Time.zone.local(3000, 8, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    description 'des'
    name 'name'
  end

  factory :invalid_time_event, class: Event do
    start_at Time.zone.local(3000, 11, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    description 'des'
    name 'name'
  end

  factory :invalid_time_event_2, class: Event do
    start_at Time.zone.local(2015, 8, 20)
    end_at Time.zone.local(2015, 10, 20)
    image 'link'
    description 'des'
    name 'name'
  end

  factory :invalid_event, class: Event do
    start_at Time.zone.local(3000, 8, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    description 'des'
  end

  factory :invalid_event_2, class: Event do
    start_at Time.zone.local(3000, 8, 20)
    end_at Time.zone.local(3000, 10, 20)
    image 'link'
    name ''
    description 'des'
  end
end
