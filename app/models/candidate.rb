class Candidate < ApplicationRecord
  validates :city, :technologies, :experience, presence: true
end
