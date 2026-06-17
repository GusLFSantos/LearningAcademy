class Badge < ApplicationRecord
  belongs_to :course
  has_many :badge_awards, dependent: :destroy
  has_many :users, through: :badge_awards

  validates :name, presence: true

  def earned_by?(user)
    return false unless user
    badge_awards.exists?(user_id: user.id)
  end
end
