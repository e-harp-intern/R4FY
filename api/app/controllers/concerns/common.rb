module Common
  extend ActiveSupport::Concern

  # ツアーの状態コード
  TOUR_STATE_CODE_INCOMPLETE = 1
  TOUR_STATE_CODE_ASSIGNED = 2
  TOUR_STATE_CODE_COMPLETE = 4
  TOUR_STATE_CODE_COMPLETE_RECORDED = 8
  TOUR_STATE_CODE_CANCEL = 256

  # URLの型（別ファイルで定義したい）
  URL_GUIDE_SCHEDULE_TOKEN = "http://localhost:8080/guides/%<token>s/schedules".freeze

  # 仮パスワードを生成
  def create_temp_pass
    (0...8).map { ("0".."9").to_a[rand(10)] }.join
  end
end
