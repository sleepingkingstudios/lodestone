# frozen_string_literal: true

require 'commands/tasks/build'

class TasksController < ApplicationController
  def create
    @task = build_task.value

    if @task.save
      redirect_to(redirect_board_path(referer_path) || task_path(@task))
    else
      @projects     = Project.all.order(:name)
      @referer_path = referer_path

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
    @projects     = Project.all.order(:name)
    @task         = Task.new(project: params[:project_id] ? project : nil)
    @referer_path = referer_path
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

  def project_board_path?(path)
    path =~ %r{/projects/[a-z0-9-]+/board}
  end

  def project_id
    params.require(:project_id)
  end

  def redirect_board_path(referer)
    return referer unless @task.project && project_board_path?(referer)

    project_board_path(@task.project)
  end

  def referer_path
    return params[:referer_path] if params[:referer_path].present?

    return nil unless request.referer&.start_with?(root_url)

    referer = request.referer[root_url.size..]
    referer = "/#{referer}" unless referer.start_with?('/')
    referer
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
