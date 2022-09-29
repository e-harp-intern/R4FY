class RemindNotifyMailer < ApplicationMailer
  def creation_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "#{ENV['MAIL_TITLE']}リマインド通知",
      to: guide.email
    )
  end
end
