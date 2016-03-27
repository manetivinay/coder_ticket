require 'rails_helper'

describe "users/_new.html.erb" do
  before(:each) do
    assign(:user, User.new(name: 'quan', email: 'quan@gmail.com'))
    render
  end

  it "should display username" do
    expect(rendered).to include('quan')
  end

  it "should display email" do
    expect(rendered).to include('quan@gmail.com')
  end

  it "should display sign in facebook" do
    expect(rendered).to include('Sigin with facebook')
  end
end