class Conference < ApplicationRecord
  has_many :talks, class_name: "Talk", foreign_key: "conference_id"

  validates :name, presence: true
end
