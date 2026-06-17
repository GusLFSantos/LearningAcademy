# Dev-only: lets you switch which seeded learner you are browsing as, so the
# progression / badge logic can be exercised for multiple users without real
# authentication. Remove once real auth lands (see ApplicationController).
class CurrentUsersController < ApplicationController
  def update
    if (user = User.find_by(id: params[:user_id]))
      session[:user_id] = user.id
    end
    redirect_back fallback_location: root_path, status: :see_other
  end
end
