class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      sign_in(:user, @user)
      redirect_to root_path, notice: 'Successful login from facebook'
    else
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
      # redirect_to new_user_registration_url
      redirect_to new_user_session_path, alert: 'Something went wrong with facebook :('
    end
  end

  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        # flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        # sign_in_and_redirect @user, :event => :authentication
        sign_in(:user, @user)
        redirect_to root_path, notice: 'Successful login from google'
      else
        # session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) #Removing extra as it can overflow some session stores
        # redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        redirect_to new_user_session_path, alert: 'Something went wrong with google :('
      end
  end

  def failure
    redirect_to root_path
  end
end
