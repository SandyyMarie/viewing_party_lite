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
      if incoming_user[:password] != incoming_user[:password_confirmation]
        flash[:error] = "Password don't match"
      else
        flash[:error] = "Sorry, something went wrong" #how to add specifically what went wrong?
      end
  
      redirect_to '/register/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
