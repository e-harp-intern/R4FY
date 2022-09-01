class Api::V1::TourdetailController < ApplicationController
  # ツアー詳細を表示
  def index
    # guide_schedules = GuideSchedule.includes(:guide)#.where(tour_id: params[:id])#.includes(:Guides)
    testa = GuideSchedule.where(tour_id: params[:id]).includes(:guide).to_json
    tours = Tour.find_by(id: params[:id])
    tour_guides = TourGuide.where(tour_id: params[:id])

    # guide_schedules_and_guide = []

    logger.debug(testa)
    # for guide_schedule in guide_schedules
    # GuideSchedule.includes(:guide)
    # end

    # for guide_schedule in guide_schedules
    # logger.debug(guide_schedules)
    #   hash = Hash.new
    #   guide = Guide.where(id:guide_schedule.guide_id)
    #   #guide_schedules_and_guide.push(guide_schedule.merge!(guide_schedules => guide))
    #   hash2 = guide_schedule

    #   hash1 = {"経営学" => 75, "会社法" => 65}

    #   hash3 = hash2.merge!(hash1)

    #   #hash["guide"] = guide
    #   guide_schedules_and_guide.push(hash3)
    #   guide_schedule = guide_schedule.guide_id

    # end

    response = { tour: tours, guide_schedules: guide_schedules, tour_guides: tour_guides }
    render json: json_render_v1(true, response)
  end
end
