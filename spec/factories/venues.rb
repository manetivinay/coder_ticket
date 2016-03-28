# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  region_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :venue, class: Venue do
    name 'location'
    address 'address'
    region
  end

  factory :invalid_venue, class: Venue do
    name 'location'
    address 'address'
  end

  factory :valid_venue, class: Venue do
    name 'location'
    address 'address'
    region_id 1
  end
end
