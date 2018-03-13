require "rails_helper"

RSpec.describe "Voter Signups", :type => :system do
  let(:room_a) { rooms(:room_a) }
  before do
    driven_by(:rack_test)
  end

  it "allows users to join rooms" do
    visit new_voter_signup_path

    fill_in :room_code, with: "1141"
    fill_in :nickname, with: "rob"
    click_button "Join Room"

    expect(page).to have_current_path(playlist_path(room_a))
  end

  it "notifies users if the room code is invalid" do
    visit new_voter_signup_path

    fill_in :room_code, with: "1142"
    fill_in :nickname, with: "rob"
    click_button "Join Room"

    expect(page).to have_text("Ooops wrong code bruh")
    expect(page).to have_current_path("/voter_signups/new")
  end

  it "roomcode is required" do
    visit new_voter_signup_path

    fill_in :nickname, with: "rob"
    click_button "Join Room"

    expect(page).to have_text("Ooops wrong code bruh")
    expect(page).to have_current_path("/voter_signups/new")
  end

  it "nickname is required" do
    visit new_voter_signup_path

    fill_in :room_code, with: "1141"
    click_button "Join Room"

    expect(page).to have_text("Nickname can't be blank")
    expect(page).to have_current_path("/voter_signups/new")
  end
end
