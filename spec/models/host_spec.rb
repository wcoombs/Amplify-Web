require 'rails_helper'

RSpec.describe Host, type: :model do
  let(:host_c) { hosts(:host_c) }
  describe "#set_api_token!" do
    subject { host_c.set_api_token! }

    it "sets a new token" do
      subject
      expect(host_c.api_token).to_not eq("supergreattoken2")
      expect(host_c.api_token).to be_present
    end
  end
end
