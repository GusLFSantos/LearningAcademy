require "test_helper"

class DarkModeLayoutTest < ActionDispatch::IntegrationTest
  setup do
    # current_user falls back to User.first; ensure one exists.
    User.create!(name: "Tester", email: "dark_layout@test.x")
  end

  test "FOUC-prevention script is in the head before the stylesheet" do
    get courses_path
    assert_response :success

    # The inline script must precede the stylesheet link so it runs synchronously
    # and prevents any flash of unstyled content on first paint.
    script_pos     = response.body.index("localStorage.getItem('darkMode')")
    stylesheet_pos = response.body.index('rel="stylesheet"')

    assert script_pos,     "FOUC prevention script not found in <head>"
    assert stylesheet_pos, "<link rel='stylesheet'> not found in response"
    assert script_pos < stylesheet_pos,
      "FOUC script must appear before the stylesheet link"
  end

  test "FOUC script applies dark class when localStorage flag is true" do
    get courses_path
    assert_response :success
    assert_match "localStorage.getItem('darkMode')", response.body
    assert_match "document.documentElement.classList.add('dark')", response.body
  end

  test "FOUC script falls back to OS color scheme preference" do
    get courses_path
    assert_response :success
    assert_match "prefers-color-scheme: dark", response.body
  end

  test "dark mode toggle button has correct Stimulus wiring" do
    get courses_path
    assert_response :success
    assert_match 'data-controller="dark-mode"', response.body
    assert_match 'data-action="click->dark-mode#toggle"', response.body
    assert_match 'aria-label="Toggle dark mode"', response.body
  end

  test "toggle button contains moon icon for light mode and sun icon for dark mode" do
    get courses_path
    assert_response :success
    # Moon hidden in dark (dark:hidden) — visible in light mode
    assert_match "dark:hidden", response.body
    # Sun hidden in light (hidden dark:block) — visible in dark mode
    assert_match "hidden dark:block", response.body
  end

  test "dark_mode_controller is wired into the importmap" do
    get courses_path
    assert_response :success
    assert_match "dark_mode_controller", response.body
  end
end
