require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe "GET #cancel" do
    it "redirects to my_orders_path with an alert message" do
      get :cancel

      expect(response).to redirect_to(my_orders_path)
      expect(flash[:alert]).to eq("Payment was cancelled.")
    end
  end
end
