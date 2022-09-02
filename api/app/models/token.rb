class Token < ApplicationRecord
  belongs_to :tour
  belongs_to :guide
end
