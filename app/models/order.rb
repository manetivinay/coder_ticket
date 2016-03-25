class Order < ActiveRecord::Base
  has_many :ticket_orders, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true, format: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_numericality_of :phone, only_integer: true
  validates_numericality_of :total_money, greater_than: 0
end
