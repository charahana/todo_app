class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks
    @total_tasks = tasks.tasks_count
    @completd_tasks = tasks.done.count
    @in_progress_tasks = tasks.in_progress.count
    @not_started_tasks = tasks.not_started.count
    @completion_rate =
      if @total_tasks.zero?
        0
      else
        (@completed_tasks.to_f / @total_tasks * 100).round
      end
    end
  end
end
