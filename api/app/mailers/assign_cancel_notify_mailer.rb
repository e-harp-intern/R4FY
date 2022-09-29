class AssignCancelNotifyMailer < ApplicationMailer
  def cancel_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "#{ENV['MAIL_TITLE']}ツアー担当ガイドについて",
      to: guide.email
    )
  end
end
