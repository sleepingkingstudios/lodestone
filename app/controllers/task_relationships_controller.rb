# frozen_string_literal: true

class TaskRelationshipsController < ApplicationController
  def create
    @relationship = TaskRelationship.new(relationship_params)

    if @relationship.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = Task.all

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
    @tasks        = Task.all
    @relationship = TaskRelationship.find(params[:id])
  end

  def new
    @source_task  = Task.find(source_task_id)
    @tasks        = Task.all
    @relationship = TaskRelationship.new(source_task: @source_task)
  end

  def update
    @relationship = TaskRelationship.find(params[:id])
    @relationship.assign_attributes(relationship_params)

    if @relationship.save
      redirect_to task_path(@relationship.source_task_id)
    else
      @source_task  = Task.find(source_task_id)
      @tasks        = Task.all

      render :edit
    end
  end

  private

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
