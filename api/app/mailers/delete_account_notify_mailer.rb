class DeleteAccountNotifyMailer < ApplicationMailer
  def delete_email(account)
    @account = account
    mail(
      subject: "#{ENV['MAIL_TITLE']}アカウント削除通知",
      to: account.email
    )
  end
end
