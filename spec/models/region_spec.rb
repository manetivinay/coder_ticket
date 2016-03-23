# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Region, type: :model do
  it { should validate_inclusion_of(:name).in_array(
      ['Ho Chi Minh', 'Ha Noi', 'Da Nang']
  ) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
