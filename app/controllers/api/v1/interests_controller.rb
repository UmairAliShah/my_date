class Api::V1::InterestsController < ApplicationController

   def create
     #debugger
     begin
       @user = User.find_by_authentication_token(params[:user_token])
       if @user && @user.profile != nil && @user.interest == nil
          @user_interest = Interest.new(set_user_interest)
          if @user.interest = @user_interest
             render json: "1", status: :Interest_Created
          else
             render json: "0", status: :Interest_Not_Created
          end
       else
         render json: "-1", status: :User_Not_Found
       end
     rescue
      render json: "-2", status: :Exception
     end
   end

  def search_people_via_interests
    begin
      @user = User.find_by_authentication_token(params[:user_token])
      if @user && @user.profile != nil && @user.interest != nil
         params[:user_id] = @user.id
         @all_users = Interest.where("user_id != #{params[:user_id]}")
         @id_arrays = []
         @filter_users = []

         @all_users.each do |u|
           #debugger
            if params[:romance] == u.romance ||
               params[:parties] == u.parties ||
               params[:selfies] == u.selfies ||
               params[:fashion] == u.fashion ||
               params[:movies]  == u.movies  ||
               params[:music]   == u.music   ||
               params[:sports]  == u.sports  ||
               params[:travelling] == u.travelling ||
               params[:culture] == u.culture ||
               params[:news]    == u.news
               @id_arrays << u.user.id
            else

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
      else
        render json: "-1", status: :User_Not_Found
      end
    rescue
      render json: "-2", status: :Exception
    end
  end

  def match_people_via_interests
    begin
       @user = User.find_by_authentication_token(params[:user_token])
       if @user && @user.profile != nil && @user.interest != nil
         @current_user_interests = @user.interest
         params[:user_gender] = @user.profile.gender
         @opposite_gender_users = Profile.where("gender != '#{params[:user_gender]}'")
         @users_interests = []
         @id_arrays = []


         @opposite_gender_users.each do |u|
            params[:user_id] = u.user_id
            @single_user_interest = Interest.where("user_id == '#{params[:user_id]}'").first
            @users_interests << @single_user_interest
         end

        @users_interests.each do |u|
          count = 0
          if @current_user_interests.romance == u.romance
             count += 1
          end
          if @current_user_interests.parties == u.parties
             count += 1
          end
          if @current_user_interests.selfies == u.selfies
             count += 1
          end
          if @current_user_interests.fashion == u.fashion
             count += 1
          end
          if @current_user_interests.movies == u.movies
             count += 1
          end
          if @current_user_interests.music == u.music
             count += 1
          end
          if @current_user_interests.sports == u.sports
             count += 1
          end
          if @current_user_interests.travelling == u.travelling
             count += 1
          end
          if @current_user_interests.culture == u.culture
             count += 1
          end
          if @current_user_interests.news == u.news
             count += 1
          end

          if count > 4
             @id_arrays << u.user.id
          end
        end

        @all_filter_users = []
        @all_filter_users_profiles = []
        if @id_arrays != nil
           @id_arrays.each do |u|
              @single_filter_user = User.where("id == '#{u}'").first
              @all_filter_users << @single_filter_user
              @single_filter_user_profile = Profile.where("user_id == '#{u}'").first
              @all_filter_users_profiles << @single_filter_user_profile
           end

           render json: { :users => @all_filter_users.as_json(:except => [:authentication_token, :email, :created_at, :updated_at]), :users_profiles => @all_filter_users_profiles.as_json(:except => [:created_at, :updated_at]) }
        else
           render json: "0", status: :Profiles_Not_Matched
        end
       else
         render json: "-1", status: :User_Not_Found
       end
    rescue
       render json: "-2", status: :Exception
    end
  end

  private
  def set_user_interest
     params.require(:interest).permit(:romance, :parties, :selfies, :fashion, :movies, :music, :sports, :travelling, :culture, :news)
  end

end
