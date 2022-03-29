# frozen_string_literal: true

require 'commands/task_relationships/assign'
require 'commands/task_relationships/build'

# Controller for managing task relationships.
class TaskRelationshipsController < ApplicationController
  def create # rubocop:disable Metrics/MethodLength
    @relationship =
      Commands::TaskRelationships::Build
      .new
      .call(attributes: relationship_params)
      .value

    if @relationship&.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = grouped_tasks

      render :new
    end
  end

  def destroy
    @relationship = TaskRelationship.find(params[:id])
    @relationship.destroy

    redirect_to task_path(@relationship.source_task_id)
  end

  def edit
    @source_task  = Task.find(source_task_id)
    @tasks        = grouped_tasks
    @relationship = TaskRelationship.find(params[:id])
  end

  def new
    @source_task  = Task.find(source_task_id)
    @tasks        = grouped_tasks
    @relationship = TaskRelationship.new(source_task: @source_task)
  end

  def update # rubocop:disable Metrics/MethodLength
    @relationship = TaskRelationship.find(params[:id])

    Commands::TaskRelationships::Assign
      .new
      .call(attributes: relationship_params, entity: @relationship)
      .value

    if @relationship.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = grouped_tasks

      render :edit
    end
  end

  private

  def grouped_tasks
    current_project = @source_task.project
    projects        =
      Project.all.where.not(id: current_project.id).order(:name)
    tasks           = Task.all.order(created_at: :desc)

    [current_project, *projects].map do |project|
      [project.name, tasks.select { |task| task.project_id == project.id }]
    end
  end

  def relationship_params
    params.require(:task_relationship).permit(
      :blocking,
      :relationship_type,
      :source_task_id,
      :target_task_id
    )
  end

  def source_task_id
    params[:task_id]
  end
end
