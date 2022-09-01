# .envから設定を読み込む

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: ENV['SMTP_HOST'],
  port: ENV['SMTP_PORT'],
  domain: ENV['SMTP_DOMAIN'],
  tls: ENV['SMTP_TLS_ENABLE'] == 'true',
  ssl: ENV['SMTP_SSL_ENABLE'] == 'true',
  enable_starttls_auto: ENV['SMTP_STARTTLS_AUTO'] == 'true',
  openssl_verify_mode: ENV['SMTP_OPENSSL_VERIFY'],
  authentication: ENV['SMTP_AUTH'],
  user_name: ENV['SMTP_AUTH_USER'],
  password: ENV['SMTP_AUTH_PASS']
}
ActionMailer::Base.default_options = {
  from: ENV['MAIL_FROM']
}
