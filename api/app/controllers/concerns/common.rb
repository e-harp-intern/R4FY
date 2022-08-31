module Common
  extend ActiveSupport::Concern

  # 仮パスワードを生成
  def create_temp_pass
    (0...8).map { ("0".."9").to_a[rand(10)] }.join
  end
end
