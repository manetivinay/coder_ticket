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
#

class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :category
  belongs_to :user
  has_many :ticket_types, dependent: :destroy

  scope :upcoming, -> { where("start_at > (?) AND is_published = (?)", Time.now, true).order('created_at asc') }
  scope :search, lambda { |key_word| upcoming.where("LOWER(name) LIKE ?", "%#{key_word.downcase}%") }

  mount_uploader :local_image, ImageUploader
  validates_presence_of :description, :venue, :category, :start_at, :image, :user_id
  validates_uniqueness_of :name, scope: [:venue_id, :start_at]

  def upcoming?
    start_at > Time.now
  end

  def format_date
    self.start_at = FormatUtils.string_to_date(self.start_at)
    self.end_at = FormatUtils.string_to_date(self.end_at)
  end
end
