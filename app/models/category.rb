# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  validates_inclusion_of :name, in: ['Âm nhạc', 'Cộng đồng', 'Hội thảo', ' Khóa học', 'Vui chơi & giải trí']
  validates_uniqueness_of :name
  validates_presence_of :name
end
