require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid without email" do
    user = User.new(password: "password123")
    expect(user).not_to be_valid
  end

  it "is valid with email and password" do
    user = User.new(email: "test@example.com", password: "password123")
    expect(user).to be_valid
  end
end
