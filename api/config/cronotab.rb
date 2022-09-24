# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#

require 'rake'
Rails.app_class.load_tasks

#Rakeタスククラスを作成
class RemindNotify
  def perform(*args)
    Rake::Task['remind_notify_mailer:send'].execute
  end
end

#スケジュール実行設定
Crono.perform(RemindNotify).every 1.days, at: '01:00' # UTC(01:00) => JP(10:00)
