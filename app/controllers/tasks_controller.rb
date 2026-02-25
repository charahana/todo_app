class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edti, :update, :destroy]

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = "タスクを作成しました"
      redirect_to tasks_path
    else
      flash[:alert] = "タスクの作成に失敗しました"
      render :new
    end
  end

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    
  end

  def edit
    
  end

  def update
    if @task.update(task_params)
      flash[:notice] = "タスクを更新しました"
      redirect_to task_path(@task)
    else
      flash[:alert] = "タスクの更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to tasks_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed, :image)
  end
end
