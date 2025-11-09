require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:client) { create(:user, role: "client") }
  let(:freelancer) { create(:user, role: "freelancer") }
  let(:service) { create(:service, user: freelancer) }
  let(:order) { create(:order, service: service, user: client) }

  before { sign_in freelancer }

  describe "PATCH #accept" do
    it "marks an order as accepted" do
      patch :accept, params: { id: order.id }
      expect(order.reload.status).to eq("accepted")
      expect(response).to redirect_to(freelancer_dashboard_path)
    end
  end

  describe "PATCH #reject" do
    it "marks an order as rejected" do
      patch :reject, params: { id: order.id }
      expect(order.reload.status).to eq("rejected")
      expect(response).to redirect_to(freelancer_dashboard_path)
    end
  end

  describe "PATCH #complete" do
    it "marks an order as completed" do
      request.env["HTTP_REFERER"] = orders_path
      patch :complete, params: { id: order.id }
      expect(order.reload.status).to eq("completed")
      expect(response).to redirect_to(orders_path)
    end
  end

  describe "PATCH #update_status" do
    context "with valid status" do
      it "updates the order status" do
        patch :update_status, params: { id: order.id, status: "in_progress" }
        expect(order.reload.status).to eq("in_progress")
        expect(response).to redirect_to(orders_path)
      end
    end

    context "with invalid status" do
      it "does not update the order" do
        patch :update_status, params: { id: order.id, status: "invalid_status" }
        expect(order.reload.status).to_not eq("invalid_status")
        expect(response).to redirect_to(orders_path)
      end
    end
  end
end

