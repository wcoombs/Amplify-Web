class LeadSignupController < ApplicationController
  def new
    @lead = Lead.new
    @lead.referrer = request.referer
  end

  def create
    params_hash = params.require(:lead).permit(:email, :referrer)
    new_lead = Lead.new(params_hash)
    new_lead.save
    flash[:notice] = "Thanks for signing up, you'll be the first to know when we launch!"
    redirect_to new_lead_signup_path
  end
end
