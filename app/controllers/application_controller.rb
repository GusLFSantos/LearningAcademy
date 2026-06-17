class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  # ---------------------------------------------------------------------------
  # AUTH TODO: This is a stubbed identity for the MVP. There is no login yet —
  # we resolve a "current user" from the session (set by the dev switcher) and
  # otherwise fall back to a seeded demo learner. Replace this whole block with
  # real authentication (e.g. `bin/rails generate authentication`) when ready.
  # ---------------------------------------------------------------------------
  def current_user
    @current_user ||=
      User.find_by(id: session[:user_id]) ||
      User.first ||
      User.create!(name: "Demo Learner", email: "demo@learningacademy.test")
  end
end
