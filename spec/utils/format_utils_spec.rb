require 'rails_helper'

RSpec.describe FormatUtils do
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