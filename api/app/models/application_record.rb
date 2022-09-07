class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # 　管理者情報をJSON化する際にpassword_digestを取り除く
  def as_json(opts = {})
    opts[:except] ||= [
      :password_digest
    ]
    super(opts)
  end
end
