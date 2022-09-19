class NotAssignMailer < ApplicationMailer
  def creation_email(guide, tour)
    @guide = guide
    @tour = tour
    mail(
      subject: "【お知らせ】ツアーの担当ガイドになりませんでした",
      to: guide.email
    )
  end
end
