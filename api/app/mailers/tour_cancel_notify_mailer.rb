class TourCancelNotifyMailer < ApplicationMailer
  def cancel_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【ツアー中止通知】ツアー中止通知",
      to: guide.email
    )
  end
end
