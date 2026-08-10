class Speaker < ApplicationRecord
  has_many :talks, class_name: "Talk", foreign_key: "speaker_id"
  has_many :conferences, -> { distinct }, through: :talks, source: :conference

  validates :name, presence: true
  validates :name, length: { maximum: 100, allow_nil: true }
end
