class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to task_path(@task), notice: "コメントを投稿しました"
    else
      redirect_to task_path(@task), alert: "コメントを入力してください"
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to task_path(@task), notice: "コメントを削除しました"
    else
      redirect_to task_path(@task), alert: "削除権限がありません"
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
