# frozen_string_literal: true

# == Schema Information
#
# Table name: saga_tasks
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  saga_id    :uuid
#  task_id    :uuid
#
# Indexes
#
#  index_saga_tasks_on_saga_id  (saga_id)
#  index_saga_tasks_on_task_id  (task_id)
#
require 'rails_helper'

RSpec.describe SagaTask, type: :model do
  pending 'To do'
end
