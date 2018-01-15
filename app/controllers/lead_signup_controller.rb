class LeadSignupController < ApplicationController
  def new
    @lead = Lead.new
    @lead.referrer = request.referer
  end

  def create
    params_hash = params.require(:lead).permit(:email, :referrer)
    new_lead = Lead.new(params_hash)
    if new_lead.save
      flash[:success] = "You will be notified when we launch."
    else
      flash[:error] = new_lead.errors.full_messages.join('<br>')
    end
    redirect_to new_lead_signup_path
  end
end
