class AssignNotifyMailer < ApplicationMailer
  def creation_email(guide,tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【割当通知】ガイド担当依頼",
      to: guide.email,
    )
  end
end
