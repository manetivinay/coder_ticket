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

class Venue < ActiveRecord::Base
  belongs_to :region

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :region_id
end
