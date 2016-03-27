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

  validates_presence_of :name, :address, :region_id
end
