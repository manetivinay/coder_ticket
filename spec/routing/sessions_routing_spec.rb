require 'rails_helper'

RSpec.describe SessionsController, type: :routing do
  describe "routing" do
    it "routes to #destroy" do
      expect(:delete => "/sessions").to route_to("sessions#destroy")
    end

    it "routes to #create" do
      expect(:post => "/sessions").to route_to("sessions#create")
    end
  end
end