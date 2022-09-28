class CreateAccountNotifyMailer < ApplicationMailer
  def creation_email(account, password)
    @account = account
    @password = password
    mail(
      subject: "【アカウント作成】システム登録のご案内",
      to: account.email
    )
  end
end
