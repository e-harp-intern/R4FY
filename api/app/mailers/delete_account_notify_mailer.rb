class DeleteAccountNotifyMailer < ApplicationMailer
  def delete_email(account)
    @account = account
    mail(
      subject: "【アカウント削除通知】観光地ガイドスケジュール調整システムのアカウント削除通知",
      to: account.email
    )
  end
end
