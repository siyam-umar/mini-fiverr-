require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:service) { Service.create!(title: "Logo Design", description: "Pro logo", price: 50, user: user) }
  let(:order) { Order.create!(service: service, user: user) }

  describe "associations" do
    it "belongs to an order" do
      submission = Submission.reflect_on_association(:order)
      expect(submission.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is invalid without a file" do
      submission = Submission.new(order: order)
      expect(submission).not_to be_valid
      expect(submission.errors[:file]).to include("can't be blank")
    end
  end

  describe "Active Storage attachment" do
    it "can attach a file" do
      submission = Submission.new(order: order)
      submission.file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test.pdf")),
        filename: "test.pdf",
        content_type: "application/pdf"
      )
      expect(submission).to be_valid
      expect(submission.file).to be_attached
    end
  end
end
