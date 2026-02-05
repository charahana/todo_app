class TasksController < ApplicationController
  before_action :authenticate_user!

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    task = current_user.tasks.find(params[:id])
    task.update(task_params)
    redirect_to task_path(task.id)
  end

  private

  def task_params
    params.require(:task).permit(:title, :completed, :image)
  end
end
