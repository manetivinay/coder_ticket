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

class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :category
  has_many :ticket_types, dependent: :destroy

  scope :upcoming, -> { where("start_at > (?)", Time.now) }
  scope :search, lambda { |key_word|
    upcoming.where("LOWER(name) LIKE ?", "%#{key_word.downcase}%")
  }

  validates_presence_of :description, :venue, :category, :start_at, :image
  validates_uniqueness_of :name, scope: [:venue_id, :start_at]

  def upcoming?
    start_at > Time.now
  end
end
