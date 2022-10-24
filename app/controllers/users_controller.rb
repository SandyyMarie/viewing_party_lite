# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @movies = @user.parties.map do |party|
      MovieFacade.movie_details(party.movie_id)
    end
  end

  def new
    @user = User.new
  end

  def create
    incoming_user = user_params
    incoming_user[:email] = incoming_user[:email].downcase
    user = User.create(incoming_user)
    if user.save
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      redirect_to '/register/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
