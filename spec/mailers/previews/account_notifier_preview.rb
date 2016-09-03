# Preview all emails at http://localhost:3000/rails/mailers/account_notifier
class AccountNotifierPreview < ActionMailer::Preview
  def send_signup_email
    AccountNotifier.send_signup_email(User.first)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, {})
  end
  
end
