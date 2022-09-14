class Tour < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  has_many :guide_schedules
  has_many :tour_guides
  has_many :tokens
  validates :end_datetime, comparison: { greater_than: :start_datetime }
  validates :adult_num, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :child_num, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :guide_num, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
