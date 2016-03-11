class ProfilesController < ApplicationController
  before_action :set_json_format, only: [:follow]
  before_action :authenticate_user!, only: [:follow]
  before_action :set_current_users_profile, only: [:edit, :update]
  before_action :set_public_profile, only: [:public_profile, :show, :follow]
  before_action :set_enums, only: [:edit]

  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:follow]

  respond_to :html

  def show    
    respond_with(@profile)
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    redirect_to public_profile_path(@profile.id)
  end

  def follow
    if current_user.following?(@profile.user)
      current_user.stop_following(@profile.user)
    else
      current_user.follow(@profile.user)
    end

    render json: {status: 200, message: 'ok', 
      followed: current_user.following?(@profile.user), followers: @profile.user.followers_count}
  end

  private
    def set_public_profile
      if params[:id].present?
        @profile = Profile.find(params[:id])
        authorize @profile        
      else 
        set_current_users_profile
      end      
    end

    def set_current_users_profile
      if current_user
        @profile = current_user.profile
        authorize @profile  
      else
        redirect_to new_user_session_path    
      end
    end    

    def set_enums
      @account_types   = Profile.account_types
      @privacies       = Profile.privacies
      @languages       = Profile.languages
      @email_privacies = Profile.email_privacies
    end    

    def profile_params
      params.require(:profile).permit(:username, :name, :avatar, :cover, :about_me, :about_library, :account_type, :privacy, :language, :allow_comments, :allow_friends, :email_privacy, :discoverable_by_email, :receive_newsletters)
    end

    def set_json_format
      request.format = :json
    end    
end
