class Course < ApplicationRecord
  has_many :lessons, -> { order(:position) }, dependent: :destroy
  has_one  :badge, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  accepts_nested_attributes_for :badge, allow_destroy: true,
    reject_if: ->(attrs) { attrs[:name].blank? }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position, :title) }

  before_validation :ensure_slug

  # Lessons that count toward completion / progression.
  def published_lessons
    lessons.where(published: true)
  end

  def enrollment_for(user)
    return nil unless user
    enrollments.find_by(user_id: user.id)
  end

  def enrolled?(user)
    enrollment_for(user).present?
  end

  def progress_for(user)
    # Fully-qualified: inside `Course`, a bare `Courses::` resolves to `Course::Courses`.
    ::Courses::Progress.call(self, user)
  end

  def status_for(user)
    progress_for(user).status
  end

  private

  def ensure_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end
end
