# frozen_string_literal: true

class BoardsController < ApplicationController
  def show
    @tasks = Task.order(updated_at: :desc).group_by(&:status)
  end
end
