class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user_from_token!, :only => [:create], :raise => false

  def create
    #debugger
    begin
      @user = User.find_by_email(params[:email])
      user_password = params[:password]
      if @user && @user.valid_password?(user_password)
        @user.authentication_token = nil
        @user.save
        render json: @user.as_json()
      else
        render json: "-1"
      end
    rescue
      render json: "-2"
    end
  end

  def destroy
    #debugger
    begin
      @user = User.find_by_authentication_token(params[:user_token])
      if @user
        @user.authentication_token = nil
        @user.save
        render json: "1", status: :Logout
      else
        render json: "-1", status: :Not_Logout
      end
    rescue
      render json: "-2"
    end
  end
end
