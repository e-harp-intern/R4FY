class TourCancelNotifyMailer < ApplicationMailer
  def cancel_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【キャンセル通知】ツアーキャンセル通知",
      to: guide.email
    )
  end
end
