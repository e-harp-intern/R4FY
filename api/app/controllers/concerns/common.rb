module Common
  extend ActiveSupport::Concern

  # ツアーの状態コード
  TOUR_STATE_CODE_INCOMPLETE = 1
  TOUR_STATE_CODE_ASSIGNED = 2
  TOUR_STATE_CODE_COMPLETE = 4
  TOUR_STATE_CODE_CANCEL = 8

  # 仮パスワードを生成
  def create_temp_pass
    (0...8).map { ("0".."9").to_a[rand(10)] }.join
  end
end
