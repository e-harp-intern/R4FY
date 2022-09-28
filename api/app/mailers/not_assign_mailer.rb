class NotAssignMailer < ApplicationMailer
  def creation_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【お知らせ】ツアー担当ガイドについて",
      to: guide.email
    )
  end
end
