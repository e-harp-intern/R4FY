module Schedule
  include Common
  extend ActiveSupport::Concern

  def schedule(guide, token)
    url = format(URL_GUIDE_SCHEDULE_TOKEN, token: token.token)
    GuideScheduleInputMailer.creation_email(guide, url).deliver_now
  end
end
