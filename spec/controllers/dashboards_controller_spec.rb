require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let(:client) { User.create!(email: "client@example.com", password: "password") }
  let(:freelancer) { User.create!(email: "freelancer@example.com", password: "password") }
  let!(:service) { Service.create!(title: "Test Service", description: "Some description", price: 100, user: freelancer) }
  let!(:order) { Order.create!(service: service, user: client, status: "pending") }

  before do
    sign_in(client) # devise helper
  end

  describe "GET #client" do
    it "returns a successful response" do
      get :client
      expect(response).to have_http_status(:success)
    end

    it "assigns the client’s orders" do
      get :client
      expect(assigns(:orders)).to include(order)
    end
  end

  describe "GET #freelancer" do
    before do
      sign_out(client)
      sign_in(freelancer)
    end

    it "returns a successful response" do
      get :freelancer
      expect(response).to have_http_status(:success)
    end

    it "assigns the freelancer’s orders" do
      get :freelancer
      expect(assigns(:orders)).to include(order)
    end
  end
end
