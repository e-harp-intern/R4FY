class RemindNotifyMailer < ApplicationMailer
  def creation_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【スケジュール調整システム】リマインド通知",
      to: guide.email
    )
  end
end
