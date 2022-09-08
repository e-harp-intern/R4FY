class CreateAccountNotifyMailer < ApplicationMailer
  def creation_email(account, password)
    @account = account
    @password = password
    mail(
      subject: "【アカウント作成通知】観光地ガイドスケジュール調整システムへの登録",
      to: account.email
    )
  end
end
