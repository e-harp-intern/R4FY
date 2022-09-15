class GuideScheduleInputMailer < ApplicationMailer
  def creation_email(guide, url, tour)
    @guide = guide
    @url = url
    @tour = tour
    mail(
      subject: "【ツアー開催通知】予定入力依頼",
      to: guide.email
    )
  end
end
