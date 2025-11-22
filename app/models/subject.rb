class Subject < ApplicationRecord
  belongs_to :course

  validates :code, presence: true
  validates :name, presence: true

  def prerequisite_codes
    prerequisites.present? ? prerequisites.split(',').map(&:strip) : []
  end
end
