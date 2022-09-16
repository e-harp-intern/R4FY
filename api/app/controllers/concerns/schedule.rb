module Schedule
  include Common
  extend ActiveSupport::Concern

  def guide_schedule_mailer(guide, token, tour)
    url = format(URL_GUIDE_SCHEDULE_TOKEN, token: token.token)
    GuideScheduleInputMailer.creation_email(guide, url, tour).deliver_now
  end
end
