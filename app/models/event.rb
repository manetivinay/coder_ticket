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

class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :category
  belongs_to :user
  has_many :ticket_types, dependent: :destroy
  delegate :region_id, to: :venue

  scope :upcoming, -> { where("start_at > (?) AND is_published = (?)", Time.now, true).order('created_at desc') }
  scope :search, lambda { |key_word| upcoming.where("LOWER(name) LIKE ?", "%#{key_word.downcase}%") }

  mount_uploader :local_image, ImageUploader
  before_validation :set_image
  validates_presence_of :description, :name, :venue_id, :category_id, :start_at, :end_at, :image, :user_id
  validates_uniqueness_of :name, scope: [:venue_id, :start_at]

  def related
    Event.upcoming.joins(:venue).where("category_id = ? AND region_id = ? AND events.id != ?",
                                       category_id, region_id, id)
  end

  def set_image
    self.image = local_image_url if local_image_url
  end

  def upcoming?
    start_at > Time.now
  end
end
