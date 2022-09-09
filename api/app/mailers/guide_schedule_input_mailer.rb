class GuideScheduleInputMailer < ApplicationMailer
  def creation_email(guide, url)
    @guide = guide
    @url = url
    mail(
      subject: "【ツアー開催通知】予定入力依頼",
      to: guide.email
    )
  end
end
