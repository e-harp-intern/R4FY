# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ガイドテストデータ
Guide.create(name: "田中としき", email: "tanaka@mail.local", is_invalid: true, memo: "東京に行きました")
Guide.create(name: "佐藤たか", email: "satou@mail.local", is_invalid: false)
Guide.create(name: "藤本みゆ", email: "hujimoto@mail.local", is_invalid: false)
Guide.create(name: "前田竜輝", email: "maeda@mail.local", is_invalid: false)
Guide.create(name: "札幌太郎", email: "sapporo05315@mail.local", is_invalid: false)
Guide.create(name: "藻岩太郎", email: "moiwa2001tarou@mail.local", is_invalid: false)
Guide.create(name: "大通り太郎", email: "1112oodori@mail.local", is_invalid: false)
Guide.create(name: "函館太郎", email: "hakodate.ika@mail.local", is_invalid: false)
Guide.create(name: "倶知安太郎", email: "kuttyan_sea@mail.local", is_invalid: false)
Guide.create(name: "室蘭太郎", email: "muroran1992@mail.local", is_invalid: false)

# ツアーテストデータ
Tour.create(name: "時計台観光", tour_state_code: 1, start_datetime: "2020-06-26T17:00:00",
            end_datetime: "2020-06-26T18:00:00", adalt_num: 10, child_num: 1, guide_num: 1, remind_date: "2020-06-25", sent_remind: true, schedule_input_deadline: "2020-06-20T21:00:00")
Tour.create(name: "大通公園観光", tour_state_code: 2, start_datetime: "2020-07-26T13:00:00",
            end_datetime: "2020-07-26T15:00:00", adalt_num: 8, child_num: 4, guide_num: 2, remind_date: "2020-07-25", sent_remind: true, schedule_input_deadline: "2020-06-20T21:00:00")
Tour.create(name: "藻岩山観光", tour_state_code: 4, start_datetime: "2020-07-28T20:00:00",
            end_datetime: "2020-07-28T22:00:00", adalt_num: 7, child_num: 0, guide_num: 1, remind_date: "2020-07-27", sent_remind: true, schedule_input_deadline: "2020-06-20T21:00:00")
Tour.create(name: "藻岩山観光", tour_state_code: 8, start_datetime: "2020-08-13T20:00:00",
            end_datetime: "2020-07-28T22:00:00", adalt_num: 12, child_num: 2, guide_num: 1, remind_date: "2020-08-12", sent_remind: true, memo: "台風のため中止", schedule_input_deadline: "2020-06-20T21:00:00")

# 管理者テストデータ
Admin.create!(name: "管理者", email: "admin@mail.local", password: "password")

for num in 1..4 do
  GuideSchedule.create(answered: true, possible: true, tour_id: 2, guide_id: num)
end

for num in 1..4 do
  TourGuide.create(achievements_entered: true, attend: true, memo: "", tour_id: num, guide_id: num)
end

TourGuide.create(achievements_entered: true, attend: true, memo: "", tour_id: 2, guide_id: num)
