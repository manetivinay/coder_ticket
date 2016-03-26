require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  before(:each) do
    @order = create(:order)
  end

  context "thank you" do
    before(:each) do
      @mail = OrderMailer.thank_you('email@email.com', @order.id)
    end

    it "should have appropriate subject" do
      expect(@mail.subject).to eq('Thank you')
    end

    it "should have appropriate sender" do
      expect(@mail.from).to include('Billet Ami')
    end

    it "should have appropriate receiver" do
      expect(@mail.to).to include('email@email.com')
    end

    it "should have username" do
      expect(@mail.body.encoded).to match(@order.username)
    end

    it "should have phone" do
      expect(@mail.body.encoded).to match(@order.phone)
    end

    it "should have email" do
      expect(@mail.body.encoded).to match(@order.email)
    end

    it "should have total_money" do
      expect(@mail.body.encoded).to match('100.000 VND')
    end
  end
end
