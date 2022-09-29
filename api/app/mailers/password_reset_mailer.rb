class PasswordResetMailer < ApplicationMailer
  def creation_email(admin, url)
    @admin = admin
    @url = url
    mail(
      subject: "#{ENV['MAIL_TITLE']}パスワードを再設定してください",
      to: admin.email
    )
  end
end
