class Item < ActiveRecord::Base
  validates :creator, presence: true
  validates :name, presence: true

  scope :still_needed, -> { where(removed_at: nil) }
end
