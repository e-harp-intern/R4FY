class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # 　API「管理者の自分自身の情報を取得する」のpassword_digestを取り除く
  def as_json(opts = {})
    opts[:except] ||= [
      :password_digest
    ]
    super(opts)
  end
end
