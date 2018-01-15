require 'rails_helper'

RSpec.describe LeadSignupController, type: :controller do
  describe "GET#new" do
    it "renders the page" do
      process(:new)
      expect(response).to have_http_status(:ok)
    end
  end
end
