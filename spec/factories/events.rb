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
end
