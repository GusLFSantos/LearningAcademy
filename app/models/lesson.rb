class Lesson < ApplicationRecord
  belongs_to :course
  has_one  :quiz, dependent: :destroy
  has_many :lesson_completions, dependent: :destroy
  has_many :lesson_time_logs, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :course_id }
  validates :estimated_minutes, numericality: { greater_than_or_equal_to: 0 }

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position) }

  before_validation :ensure_slug

  def completed_by?(user)
    return false unless user
    lesson_completions.exists?(user_id: user.id)
  end

  def time_spent_seconds_for(user)
    return 0 unless user
    lesson_time_logs.where(user_id: user.id).sum(:seconds)
  end

  def next_lesson
    course.lessons.ordered.find_by("position > ?", position)
  end

  def previous_lesson
    course.lessons.ordered.where("position < ?", position).last
  end

  private

  def ensure_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end
end
