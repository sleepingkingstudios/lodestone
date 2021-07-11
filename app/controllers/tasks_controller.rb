# frozen_string_literal: true

require 'commands/tasks/build'

class TasksController < ApplicationController
  def create
    @task = build_task.value

    if @task.save
      redirect_to task_path(@task)
    else
      @projects = Project.all.order(:name)

      render :new
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path
  end

  def edit
    @projects = Project.all.order(:name)
    @task     = Task.find(params[:id])
  end

  def new
    @projects = Project.all.order(:name)
    @task     = Task.new
  end

  def index
    @tasks = Task.all.includes(:project).order(:slug)
  end

  def show
    @task                  = Task.find(params[:id])
    @relationships         = @task.relationships.includes(:target_task)
    @inverse_relationships = @task.inverse_relationships.includes(:source_task)
  end

  def update
    @task = Task.find(params[:id])
    @task.assign_attributes(task_params)

    if @task.save
      redirect_to task_path(@task)
    else
      @projects = Project.all.order(:name)

      render :edit
    end
  end

  private

  def build_task
    Commands::Tasks::Build
      .new
      .call(attributes: task_params, project: project)
  end

  def project
    Project.find(project_id)
  end

  def project_id
    params.require(:project_id)
  end

  def task_params
    params.require(:task).permit(
      :description,
      :status,
      :task_type,
      :title
    )
  end
end
