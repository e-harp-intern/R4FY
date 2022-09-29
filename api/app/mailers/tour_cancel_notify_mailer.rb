class TourCancelNotifyMailer < ApplicationMailer
  def cancel_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "#{ENV['MAIL_TITLE']}ツアー中止通知",
      to: guide.email
    )
  end
end
