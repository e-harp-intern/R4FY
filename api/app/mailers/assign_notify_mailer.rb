class AssignNotifyMailer < ApplicationMailer
  def creation_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "#{ENV['MAIL_TITLE']}ガイド担当依頼",
      to: guide.email
    )
  end
end
