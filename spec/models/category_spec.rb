# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should validate_inclusion_of(:name).in_array(
      ['Âm nhạc', 'Cộng đồng', 'Hội thảo', ' Khóa học', 'Vui chơi & giải trí']
  ) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
