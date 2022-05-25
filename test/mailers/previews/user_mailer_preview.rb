# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

#クラウドIDEの場合は下だろう
  #アカウント有効化メールでプレビューするためのもの
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Preview this email at http://<hex string>.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

#クラウドIDEの場合は下だろう
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  # Preview this email at http://<hex string>.vfs.cloud9.us-east-2.amazonaws.com/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end
