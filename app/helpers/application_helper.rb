module ApplicationHelper
  # "1h 5m", "12m", "45s" — compact human duration from a number of seconds.
  def humane_duration(seconds)
    seconds = seconds.to_i
    return "0m" if seconds <= 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    parts = []
    parts << "#{hours}h" if hours.positive?
    parts << "#{minutes}m" if minutes.positive?
    parts << "#{secs}s" if hours.zero? && minutes.zero? && secs.positive?
    parts.join(" ")
  end

  # "mm:ss" clock format, used for quiz attempt durations.
  def clock_duration(seconds)
    seconds = seconds.to_i
    format("%d:%02d", seconds / 60, seconds % 60)
  end
end
