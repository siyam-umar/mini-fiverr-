require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { User.create!(email: "client@example.com", password: "password123") }
  let(:service) { Service.create!(title: "Logo Design", description: "Professional logo design", price: 100, user: user) }

  describe "associations" do
    it { should belong_to(:service) }
    it { should belong_to(:user) }
    it { should have_one(:submission) }
  end

  describe "enums" do
    it "has correct statuses" do
      expect(Order.statuses.keys).to contain_exactly("pending", "accepted", "rejected", "in_progress", "completed")
    end

    it "defaults to pending" do
      order = Order.create!(service: service, user: user)
      expect(order.status).to eq("pending")
    end

    it "can transition to accepted" do
      order = Order.create!(service: service, user: user)
      order.accepted!
      expect(order.status).to eq("accepted")
    end

    it "can transition to completed" do
      order = Order.create!(service: service, user: user)
      order.completed!
      expect(order.status).to eq("completed")
    end
  end
end
