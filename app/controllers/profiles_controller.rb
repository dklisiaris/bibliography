class ProfilesController < ApplicationController
  
  before_action :set_current_users_profile, only: [:edit, :update]
  before_action :set_public_profile, only: [:public_profile, :show]
  before_action :set_enums, only: [:edit]

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
      @profile = current_user.profile
      authorize @profile
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
end
