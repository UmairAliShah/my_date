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
        @user_profile = @user.profile
        if @user.profile != nil
           render json:  { :user => @user.as_json(:except => [:id, :email, :created_at, :updated_at]), :user_profile => @user_profile.as_json(:except => [:created_at, :updated_at]) }
        else
           render json:  "0", status: :Profile_Not_Exists
        end
        #render json: @user.as_json(:except => [:id, :email, :created_at, :updated_at])

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
