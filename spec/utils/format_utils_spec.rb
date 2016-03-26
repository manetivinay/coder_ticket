require 'rails_helper'

RSpec.describe FormatUtils do
  describe '#format_price' do
    it "should format to VND short price" do
      expect(FormatUtils.format_price(100)).to eq('100 VND')
    end

    it "should format to VND long price" do
      expect(FormatUtils.format_price(20000)).to eq('20.000 VND')
    end

    it "should format to VND very long price" do
      expect(FormatUtils.format_price(100000000)).to eq('100.000.000 VND')
    end
  end

  describe 'string_to_date' do
    before(:each) do
      @date = FormatUtils.string_to_date('10 March, 2016')
    end

    it "should return right day" do
      expect(@date.day).to eq(10)
    end

    it "should return right month" do
      expect(@date.month).to eq(3)
    end

    it "should return right year" do
      expect(@date.year).to eq(2016)
    end
  end
end