# frozen_string_literal: true

# Controller for managing task relationships.
class TaskRelationshipsController < ApplicationController
  def new
    @source_task  = Task.find(source_task_id)
    @tasks        = grouped_tasks
    @relationship = TaskRelationship.new(source_task: @source_task)
  end

  def edit
    @source_task  = Task.find(source_task_id)
    @tasks        = grouped_tasks
    @relationship = TaskRelationship.find(params[:id])
  end

  def create
    @relationship = TaskRelationship.new(relationship_params)

    if @relationship&.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = grouped_tasks

      render :new
    end
  end

  def update
    @relationship = TaskRelationship.find(params[:id])
    @relationship.assign_attributes(relationship_params)

    if @relationship.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = grouped_tasks

      render :edit
    end
  end

  def destroy
    @relationship = TaskRelationship.find(params[:id])
    @relationship.destroy

    redirect_to task_path(@relationship.source_task_id)
  end

  private

  def grouped_tasks
    current_project = @source_task.project
    projects        =
      Project.where.not(id: current_project.id).order(:name)
    tasks           = Task.order(created_at: :desc)

    [current_project, *projects].map do |project|
      [project.name, tasks.select { |task| task.project_id == project.id }]
    end
  end

  def relationship_params
    params.expect(
      task_relationship: %i[relationship_type source_task_id target_task_id]
    )
  end

  def source_task_id
    params[:task_id]
  end
end
