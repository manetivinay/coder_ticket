require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_numericality_of(:total_money) }
  it { should validate_presence_of(:username) }
  it { should validate_numericality_of(:phone).only_integer }
  it { should validate_presence_of(:email) }
  it { should_not allow_value('test@test').for(:email) }
  it { should_not allow_value('android').for(:email) }
  it { should_not allow_value('ios.@..c').for(:email) }
  it { should allow_value('vuhuyquan@apidez.com').for(:email) }
  it { should have_many(:ticket_orders).dependent(:destroy) }
end
