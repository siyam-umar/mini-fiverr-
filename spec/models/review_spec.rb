require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { User.create!(email: "user@test.com", password: "password") }
  let(:service) { Service.create!(title: "Test Service", description: "Good work", price: 100, user: user) }

  subject { described_class.new(user: user, service: service, rating: 5, comment: "Excellent work!") }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:service) }
  end

  describe "validations" do
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_presence_of(:comment) }
  end

  describe "valid review" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end

  describe "invalid review" do
    it "is invalid without a rating" do
      subject.rating = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with rating outside 1..5" do
      subject.rating = 6
      expect(subject).not_to be_valid
    end

    it "is invalid without a comment" do
      subject.comment = nil
      expect(subject).not_to be_valid
    end
  end
end
