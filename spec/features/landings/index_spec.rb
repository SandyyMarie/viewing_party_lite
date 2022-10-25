# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landing Page' do
  describe 'user visits landing page' do
    before :each do
      @users_1 = create_list(:user, 20)
    end

    it 'shows landing page information' do
      visit '/'

      expect(page).to have_content('Viewing Party Lite')
      click_button 'Create New User'
      expect(current_path).to eq(new_user_path)

      visit '/'

      within '#users-list' do
        expect(page).to have_content(@users_1[0].name)
        expect(page).to have_content(@users_1[1].name)
      end

      click_link @users_1[0].name.to_s
      expect(current_path).to eq(user_path(@users_1[0]))
    end

    describe "Logging In" do
      it "can log in with valid credentials" do
        user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')

        visit root_path

        click_on "I already have an account"

        expect(current_path).to eq(login_path)

        fill_in :username, with: user.username
        fill_in :password, with: user.password

        click_on "Log In"

        expect(current_path).to eq(root_path)

        expect(page).to have_content("Welcome, #{user.username}")
      end
    end
  end
end
