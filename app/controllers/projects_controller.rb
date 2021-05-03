# frozen_string_literal: true

class ProjectsController < ApplicationController
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def destroy
    Project.find(params[:id]).destroy

    redirect_to projects_path
  end

  def edit
    @project = Project.find(params[:id])
  end

  def index
    @projects = Project.order(:name)
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.assign_attributes(project_params)

    if @project.save
      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :active,
      :description,
      :name,
      :project_type,
      :public,
      :repository,
      :slug
    )
  end
end
