class Tour < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  has_many :guide_schedules
  has_many :tour_guides
  has_many :tokens
  validates :end_datetime, comparison: { greater_than: :start_datetime }
end
