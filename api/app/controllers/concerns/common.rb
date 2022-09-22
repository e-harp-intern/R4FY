module Common
  extend ActiveSupport::Concern

  # ツアーの状態コード
  TOUR_STATE_CODE_INCOMPLETE = 1
  TOUR_STATE_CODE_ASSIGNED = 2
  TOUR_STATE_CODE_COMPLETE = 32
  TOUR_STATE_CODE_CANCEL = 256

  # URLの型（別ファイルで定義したい）
  URL_GUIDE_SCHEDULE_TOKEN = "#{ENV['SERVER_PATH']}#{'/guides/%<token>s/schedules'.freeze}".freeze
  URL_ADMIN_PASSWORD_RESET_TOKEN = "#{ENV['SERVER_PATH']}#{'/reset/%<token>s'.freeze}".freeze

  # 仮パスワードを生成
  def create_temp_pass
    (0...8).map { ("0".."9").to_a[rand(10)] }.join
  end

  # トークンの生成
  def generate_token
    SecureRandom.urlsafe_base64
  end
end
