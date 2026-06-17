require "test_helper"

# In CI (GitHub Actions sets CI=true) drive with the pre-installed headless
# Chrome on the runner — no separate Selenium container needed.
#
# Locally (Docker Compose) drive with the remote Chrome in the selenium service.
# The Capybara server binds to 0.0.0.0 so the remote browser can reach it via
# the compose hostname "web".
if ENV["CI"]
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1200 ]
  end
else
  SELENIUM_URL = ENV.fetch("SELENIUM_URL", "http://selenium:4444")
  APP_HOST     = ENV.fetch("CAPYBARA_APP_HOST", "web")
  APP_PORT     = Integer(ENV.fetch("CAPYBARA_SERVER_PORT", "3001"))

  Capybara.register_driver :remote_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1400,1200")
    Capybara::Selenium::Driver.new(app, browser: :remote, url: SELENIUM_URL, options: options)
  end

  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = APP_PORT
    Capybara.app_host    = "http://#{APP_HOST}:#{APP_PORT}"

    driven_by :remote_chrome
  end
end
