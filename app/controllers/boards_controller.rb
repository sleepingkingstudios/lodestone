# frozen_string_literal: true

class BoardsController < ApplicationController
  def show
    @project = project
    @tasks   = grouped_tasks
  end

  private

  def grouped_tasks
    tasks = Task.order(updated_at: :desc)
    tasks = tasks.where(project: project) if project
    tasks.group_by(&:status)
  end

  def project
    return @project if @project
    return nil      if project_id.blank?

    @project = Project.find(project_id)
  end

  def project_id
    params[:project_id]
  end
end
