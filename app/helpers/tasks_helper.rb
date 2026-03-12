module TasksHelper
  def status_badge_class(status)
    case status
    when "not_started"
      "bg-secondary"
    when "in_progress"
      "bg-primary"
    when "completed"
      "bg-success"
    else
      "bg-light"
    end
  end
end