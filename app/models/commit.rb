class Commit < ApplicationRecord
  belongs_to :contributor

  validates :sha, presence: true, uniqueness: true
end
