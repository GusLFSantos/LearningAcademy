class ProfileController < ApplicationController
  def show
    @user = current_user
    @enrollments = @user.enrollments.includes(course: :badge).order(:created_at)
    @badge_awards = @user.badge_awards.includes(badge: :course).order(awarded_at: :desc)
    @total_time = @user.total_time_spent_seconds
  end
end
