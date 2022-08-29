# config/mail.ymlの設定を読み込む

RAILS_ROOT = File.expand_path('../../../', __FILE__)

mail_settings = YAML.load(File.read("#{RAILS_ROOT}/config/mail.yml"))

ActionMailer::Base.delivery_method = mail_settings['method']
ActionMailer::Base.smtp_settings = mail_settings['settings']
ActionMailer::Base.default_options = mail_settings['default_options']