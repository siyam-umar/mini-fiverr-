require 'rails_helper'

RSpec.describe Service, type: :model do
  let(:user) { User.create!(email: "test@test.com", password: "password") }
  subject { described_class.new(title: "Web Design", description: "I will design a website", price: 100, user: user) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "valid service" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end

  describe "invalid service" do
    it "is invalid without a title" do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with price <= 0" do
      subject.price = 0
      expect(subject).not_to be_valid
    end
  end
end
