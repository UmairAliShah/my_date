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
    #debugger
    begin
       @user = User.find_by_authentication_token(params[:user_token])
       if @user && @user.profile != nil && @user.interest != nil
          params[:user_gender] = @user.profile.gender
          @opposite_gender_users = Profile.where("gender != '#{params[:user_gender]}'")
          @id_arrays = []
          @filter_users = []
          count = 0
          @opposite_gender_users.each do |u|
             if params[:romance] == u.romance
                count++
                if params[:parties] == u.parties
                  count++
                  if params[:selfies] == u.selfies
                     count++
                     if params[:fashion] == u.fashion
                        count++
                        if params[:movies]  == u.movies
                           count++
                           if params[:music]   == u.music
                              count++
                              if params[:sports]  == u.sports
                                 count++
                                 if params[:travelling] == u.travelling
                                    count++
                                    if params[:culture] == u.culture
                                       count++
                                       if params[:news] == u.news
                                          count++
                                       elsif
                                       end
                                    elsif
                                    end
                                 elsif
                                 end
                              elsif
                              end
                           elsif
                           end
                        elsif
                        end
                     elsif
                     end
                  elsif
                  end
                elsif
                end
             elsif params[:romance] != u.romance
                   if params[:parties] == u.parties
                      count++
                      if params[:selfies] == u.selfies
                         count++
                         if params[:fashion] == u.fashion
                            count++
                            if params[:movies]  == u.movies
                               count++
                              if params[:music] == u.music
                                 count++
                                 if params[:sports]  == u.sports
                                    count++
                                    if params[:travelling] == u.travelling
                                       count++
                                       if params[:culture] == u.culture
                                          count++
                                          if params[:news] == u.news
                                             count++
                                          elsif params[:news] != u.news
                                          end
                                       elsif params[:culture] != u.culture
                                       end
                                    elsif params[:travelling] != u.travelling
                                    end
                                 elsif params[:sports] != u.sports
                                 end
                              elsif params[:music] != u.music
                              end
                            elsif params[:movies]  != u.movies
                            end
                         elsif params[:fashion] != u.fashion
                         end
                      elsif params[:selfies] != u.selfies
                      end
                   elsif params[:parties] != u.parties
                   end
             end
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
