require "application_system_test_case"

class DarkModeSystemTest < ApplicationSystemTestCase
  setup do
    User.create!(name: "Tester", email: "dark_sys@test.x")
  end

  # Helpers

  def dark_mode_active?
    page.evaluate_script("document.documentElement.classList.contains('dark')")
  end

  def stored_preference
    page.evaluate_script("localStorage.getItem('darkMode')")
  end

  def force_light_mode
    page.execute_script(
      "localStorage.setItem('darkMode','false'); document.documentElement.classList.remove('dark')"
    )
  end

  def force_dark_mode
    page.execute_script(
      "localStorage.setItem('darkMode','true'); document.documentElement.classList.add('dark')"
    )
  end

  def toggle_button
    find("button[aria-label='Toggle dark mode']")
  end

  # Tests

  test "clicking toggle from light mode enables dark mode" do
    visit courses_path
    force_light_mode

    refute dark_mode_active?, "expected to start in light mode"
    toggle_button.click
    assert dark_mode_active?, "expected dark class on <html> after toggle"
  end

  test "clicking toggle from dark mode disables dark mode" do
    visit courses_path
    force_dark_mode

    assert dark_mode_active?, "expected to start in dark mode"
    toggle_button.click
    refute dark_mode_active?, "expected dark class to be removed after toggle"
  end

  test "toggling saves preference to localStorage" do
    visit courses_path
    force_light_mode

    toggle_button.click
    assert_equal "true", stored_preference, "expected 'true' in localStorage after enabling dark"

    toggle_button.click
    assert_equal "false", stored_preference, "expected 'false' in localStorage after disabling dark"
  end

  test "dark mode preference persists across page navigation" do
    visit courses_path
    force_light_mode
    toggle_button.click
    assert dark_mode_active?

    # Navigate to a different page — FOUC script re-applies the class on load
    visit profile_path
    assert dark_mode_active?, "dark mode should persist after navigating to a new page"
  end

  test "light mode preference persists across page navigation" do
    visit courses_path
    force_dark_mode
    toggle_button.click
    refute dark_mode_active?

    visit profile_path
    refute dark_mode_active?, "light mode should persist after navigating to a new page"
  end

  test "page loads in dark mode when localStorage flag is pre-set" do
    visit courses_path
    # Seed the preference before the real page load
    page.execute_script("localStorage.setItem('darkMode','true')")
    visit courses_path

    assert dark_mode_active?,
      "FOUC script should apply dark class on load when localStorage darkMode=true"
  end

  test "page loads in light mode when localStorage flag is false" do
    visit courses_path
    page.execute_script("localStorage.setItem('darkMode','false')")
    visit courses_path

    refute dark_mode_active?,
      "FOUC script should NOT apply dark class when localStorage darkMode=false"
  end
end
