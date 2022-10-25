require 'rails_helper'

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')

    visit root_path

    click_on "I already have an account"

    expect(current_path).to eq(login_path)

    fill_in 'Email:', with: user.email
    fill_in 'Password:', with: user.password
    fill_in 'Confirm Password:', with: user.password
    click_on "Log In"

    expect(current_path).to eq(root_path)

    expect(page).to have_content("Welcome, #{user.email}")
  end
end