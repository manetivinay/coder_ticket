# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  total_money :decimal(, )
#  username    :string
#  email       :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe OrdersController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(:get => "/orders/new").to route_to("orders#new")
    end

    it "routes to #create" do
      expect(:post => "/orders").to route_to("orders#create")
    end
  end
end
