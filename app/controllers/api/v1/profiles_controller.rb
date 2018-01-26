class Api::V1::ProfilesController < ApplicationController

  def create
   begin

       @user = User.find_by_authentication_token(params[:user_token])
       #@user = User.find_by_email(params[:user_email])
       if @user && @user.profile == nil
          @new_profile = Profile.new(set_profile)
          if @user.profile = @new_profile
             render json: @new_profile.as_json()
          else
             render json: "0", status: :Profile_Not_Saved
          end
       else
          render json: "-1", status: :User_Not_Found
       end
   rescue
     render json: "-2"
   end
 end

 def update
     begin
         @user = User.find_by_authentication_token(params[:user_token])
         if @user && @user.profile != nil
            @profile_to_be_Changed = @user.profile
            if @profile_to_be_Changed.update(set_profile)
               render json: @profile_to_be_Changed.as_json()
            else
               render json: "0", status: :Profile_Not_Update
            end
         else
            render json: "-1", status: :User_Not_Found
         end
     rescue
       render json: "-2"
     end
 end

 def update_img
    begin
       @user = User.find_by_authentication_token(params[:user_token])
       if @user && @user.profile != nil
          @profile_img_to_be_Changed = @user.profile
          if @profile_img_to_be_Changed.update(update_img_url)
             render json: @profile_img_to_be_Changed.as_json()
          else
             render json: "0", status: :Profile_Img_Not_Update
          end
       else
          render json: "-1", status: :User_Not_Found
       end
    rescue
     render json: "-2"
    end
  end



  def set_online
    begin
      @user = User.find_by_authentication_token(params[:user_token])
      if @user && @user.profile != nil
        @set_profile_online = @user.profile
        @set_profile_online.is_online = true
        if @set_profile_online.save
          render json: "1", status: :make_online
        else
          render json: "0", status: :Still_Offline
        end
      else
        render json: "-1", status: :User_Not_Found
      end
    rescue
      render json: "-2"
    end
  end


  def set_offline
  begin
    @user = User.find_by_authentication_token(params[:user_token])
    if @user && @user.profile != nil
      @set_profile_offline = @user.profile
      @set_profile_offline.is_online = false
      if @set_profile_offline.save
        render json: "1", status: :make_offline
      else
        render json: "0", status: :Still_Online
      end
    else
      render json: "-1", status: :User_Not_Found
    end
  rescue
    render json: "-2"
  end
end


 def update_location
    #debugger
    begin
      @user = User.find_by_authentication_token(params[:user_token])
      if @user && @user.profile != nil
        @update_user_location = @user.profile
        if @update_user_location.update(update_location_params)
          render json: "1", status: :Location_Is_Updated
        else
          render json: "0", status: :Location_Is_Not_Updated
        end
      else
        render json: "-1", status: :User_Not_Found
      end
    rescue
      render json: "-2"
    end
  end

  def distance
    #debugger
    begin
      @user = User.find_by_authentication_token(params[:user_token])
      if @user && @user.profile != nil
        params[:id] = @user.id
        @all_users = Profile.where("user_id != '#{params[:id]}'")
        if params[:distance] == 5
          render json: @all_users.as_json()
        else
          lat1 = @user.profile.latitude
          long1 = @user.profile.longitude
          @id_arrays = []#Array.new{[]}
          @filter_users = []#Array.new{[]}

          @all_users.each do |u|

            @distance  = Geocoder::Calculations.distance_between([lat1,long1], [u.latitude,u.longitude])
            @distance = Geocoder::Calculations.to_kilometers(@distance)
            if @distance > 0 && @distance <= 500 && params[:distance] == 4
              @id_arrays << u.user.id
            elsif @distance > 0 && @distance <= 300 && params[:distance] == 3
              @id_arrays << u.user.id
            elsif @distance > 0 && @distance <= 100 && params[:distance] == 2
              @id_arrays << u.user.id
            elsif @distance > 0 && @distance <= 50 && params[:distance] == 1
              @id_arrays << u.user.id
            elsif @distance > 0 && @distance <= 20 && params[:distance] == 0
              @id_arrays << u.user.id
            end
          end

          if @id_arrays != nil
              @id_arrays.each do |i|
                @single_filter_user = Profile.where("user_id == #{i}")
                @filter_users << @single_filter_user
              end
            render json: @filter_users.as_json(), status: :Filter_Users
          else
            rener json: "0", status: :Users_Not_Exists
          end
        end
      else
        render json: "-1"
      end
    rescue
       render json: "-2"
    end
  end

  private

  def set_profile
    params.require(:profile).permit(:first_name, :last_name, :state, :city, :country, :code, :provider, :phone_no, :provider_id,:img_url, :address, :gender, :about_me, :interested_in, :date_of_birth)
  end

  def update_img_url
     params.require(:profile).permit(:img_url)
  end

  def update_location_params
    params.require(:profile).permit(:longitude, :latitude)
  end


end
