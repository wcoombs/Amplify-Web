require 'rails_helper'

RSpec.describe LeadSignupsController, type: :controller do
  describe "GET#new" do
    it "renders the page" do
      process(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST#create" do
    it "creates a new lead" do
      expect do
        process(:create, params: { lead: { email: "robert@example.com", referrer: nil } })
      end.to change { Lead.count }.by(1)

      expect(flash[:notice]).to eq("Thanks for signing up, you'll be the first to know when we launch!")
      expect(response).to redirect_to(new_lead_signup_path)
    end
  end
end
