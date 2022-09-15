class AssignCancelNotifyMailer < ApplicationMailer
  def cancel_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【担当取り消し通知】ツアー担当ガイド取り消し通知",
      to: guide.email
    )
  end
end
