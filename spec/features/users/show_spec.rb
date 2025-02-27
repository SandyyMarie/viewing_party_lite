# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Dashboard Page' do
  describe 'user visits the dashboard page' do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)

      @party_1 = create(:party, movie_id: 278, host_id: @user_3.id) # shawshank
      @party_2 = create(:party, movie_id: 889, host_id: @user_3.id) # flinstones
      @party_3 = create(:party, movie_id: 254, host_id: @user_3.id)
      @party_4 = create(:party, movie_id: 889, host_id: @user_3.id)
      @party_5 = create(:party, movie_id: 254, host_id: @user_3.id)
      @party_6 = create(:party, movie_id: 889, host_id: @user_1.id)
      @party_7 = create(:party, movie_id: 278, host_id: @user_2.id)

      create(:user_parties, user_id: @user_1.id, party_id: @party_1.id)
      create(:user_parties, user_id: @user_2.id, party_id: @party_1.id)
      create(:user_parties, user_id: @user_3.id, party_id: @party_1.id)
      create(:user_parties, user_id: @user_1.id, party_id: @party_2.id)
      create(:user_parties, user_id: @user_1.id, party_id: @party_3.id)
      create(:user_parties, user_id: @user_2.id, party_id: @party_4.id)
      create(:user_parties, user_id: @user_2.id, party_id: @party_5.id)
      create(:user_parties, user_id: @user_3.id, party_id: @party_6.id)
      create(:user_parties, user_id: @user_1.id, party_id: @party_6.id)
      create(:user_parties, user_id: @user_3.id, party_id: @party_7.id)
      create(:user_parties, user_id: @user_2.id, party_id: @party_7.id)
      create(:user_parties, user_id: @user_1.id, party_id: @party_7.id)
    end

    it 'shows users name at the top of the page' do
      visit user_path(@user_1)
      expect(page).to have_content("#{@user_1.name}'s Dashboard")

      visit user_path(@user_2)
      expect(page).to have_content("#{@user_2.name}'s Dashboard")
    end

    it 'has a button to discover movies' do
      visit user_path(@user_1)
      click_button 'Discover Movies'
      expect(current_path).to eq(user_discover_index_path(@user_1))

      visit user_path(@user_2)
      click_button 'Discover Movies'
      expect(current_path).to eq(user_discover_index_path(@user_2))
    end

    it 'shows the viewing parties the user has been invited to with details', :vcr do
      visit user_path(@user_3)

      within('#attending') do
        within("#party-#{@party_7.id}") do
          expect(page).to have_content(@party_7.start_time)
          expect(page).to have_content(@party_7.date)
          expect(page).to have_content("Host: #{@user_2.name}")
          expect(page).to have_content(@user_3.name.to_s)
          expect(page).to have_content('Shawshank Redemption')

          expect(page).to_not have_content('King Kong')

          click_link 'Shawshank Redemption'
        end
      end

      expect(current_path).to eq(user_movie_path(@user_3, @party_7.movie_id))
    end

    it 'shows the viewing parties the user has created with details (host)' do
      visit user_path(@user_1)

      within('#hosting') do
        within("#party-#{@party_6.id}") do
          expect(page).to have_content(@party_6.start_time)
          expect(page).to have_content(@party_6.date)
          expect(page).to have_content("Host: #{@user_1.name}")
          expect(page).to have_content(@user_3.name.to_s)
          expect(page).to have_content('The Flintstones in Viva Rock Vegas')

          expect(page).to_not have_content(@user_2.name)

          click_link 'The Flintstones in Viva Rock Vegas'
        end
      end
      expect(current_path).to eq(user_movie_path(@user_1, @party_4.movie_id)) # fix routing
    end
  end
end
