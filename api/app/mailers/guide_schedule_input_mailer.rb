class GuideScheduleInputMailer < ApplicationMailer
  def creation_email(guide, url, tour)
    @guide = guide
    @url = url
    @tour = tour
    mail(
      subject: "【予定入力依頼】ツアー開催のご案内",
      to: guide.email
    )
  end
end
