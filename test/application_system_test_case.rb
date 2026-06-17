require "test_helper"

# System tests drive a real headless Chromium running in the `selenium` service.
# The Capybara app server runs inside the `web` container bound to 0.0.0.0, and
# the remote browser reaches it via the compose hostname `web`.
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
  Capybara.app_host = "http://#{APP_HOST}:#{APP_PORT}"

  driven_by :remote_chrome
end
