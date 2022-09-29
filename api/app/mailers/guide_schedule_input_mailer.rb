class GuideScheduleInputMailer < ApplicationMailer
  def creation_email(guide, url, tour)
    @guide = guide
    @url = url
    @tour = tour
    mail(
      subject: "#{ENV['MAIL_TITLE']}ツアー開催のご案内",
      to: guide.email
    )
  end
end
