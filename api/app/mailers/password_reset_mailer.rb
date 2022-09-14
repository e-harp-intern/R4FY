class PasswordResetMailer < ApplicationMailer
  def creation_email(admin, url)
    @admin = admin
    @url = url
    mail(
      subject: "【パスワードリセット通知】パスワード再設定依頼",
      to: admin.email
    )
  end
end
