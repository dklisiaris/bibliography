class AccountNotifier < ApplicationMailer
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => t('mailer.thanks_for_signup') )
  end
end
