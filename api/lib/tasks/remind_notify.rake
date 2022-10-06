namespace :remind_notify_mailer do
  task send: :environment do
    # 設定
    TOUR_STATE_CODE_ASSIGNED = 2

    # 取得する日付
    start_datetime = Date.tomorrow.midnight
    end_datetime = Date.tomorrow.end_of_day

    # 対象ツアーの取得
    tours = Tour
            .where(tour_state_code: TOUR_STATE_CODE_ASSIGNED)
            .where(send_remind: true)
            .where("start_datetime >= ?", start_datetime)
            .where("start_datetime <= ?", end_datetime)

    # ツアーごとに処理
    tours.each do |tour|
      guides = TourGuide.where(tour_id: tour.id)
      guides.each do |guide|
        RemindNotifyMailer.creation_email(Guide.find(guide.guide_id), tour).deliver_now
      end
    end
  end
end
