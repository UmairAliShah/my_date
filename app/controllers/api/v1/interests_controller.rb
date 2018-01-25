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
         render json: @id_arrays
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
