# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lodestone::Tasks::View::Components do
  describe '#format_status' do
    let(:status)    { nil }
    let(:formatted) { described_class.format_status(status) }
    let(:expected)  { status&.titleize }

    it 'should define the class method' do
      expect(described_class).to respond_to(:format_status).with(1).argument
    end

    describe 'with nil' do
      it { expect(formatted).to be nil }
    end

    describe 'with "Archived"' do
      let(:status) { Task::Statuses::ARCHIVED }

      it { expect(formatted).to be == expected }
    end

    describe 'with "Done"' do
      let(:status) { Task::Statuses::DONE }

      it { expect(formatted).to be == expected }
    end

    describe 'with "Icebox"' do
      let(:status) { Task::Statuses::ICEBOX }

      it { expect(formatted).to be == expected }
    end

    describe 'with "In Progress"' do
      let(:status) { Task::Statuses::IN_PROGRESS }

      it { expect(formatted).to be == expected }
    end

    describe 'with "To Do"' do
      let(:status) { Task::Statuses::TO_DO }

      it { expect(formatted).to be == expected }
    end

    describe %(with "Won't Do") do
      let(:status)   { Task::Statuses::WONT_DO }
      let(:expected) { "Won't Do" }

      it { expect(formatted).to be == expected }
    end
  end

  describe '#status_color' do
    let(:status) { nil }
    let(:color)  { described_class.status_color(status) }

    it 'should define the class method' do
      expect(described_class).to respond_to(:status_color).with(1).argument
    end

    describe 'with nil' do
      it { expect(color).to be == 'text' }
    end

    describe 'with "Archived"' do
      let(:status) { Task::Statuses::ARCHIVED }

      it { expect(color).to be == 'text' }
    end

    describe 'with "Done"' do
      let(:status) { Task::Statuses::DONE }

      it { expect(color).to be == 'slate' }
    end

    describe 'with "Icebox"' do
      let(:status) { Task::Statuses::ICEBOX }

      it { expect(color).to be == 'info' }
    end

    describe 'with "In Progress"' do
      let(:status) { Task::Statuses::IN_PROGRESS }

      it { expect(color).to be == 'success' }
    end

    describe 'with "To Do"' do
      let(:status) { Task::Statuses::TO_DO }

      it { expect(color).to be == 'link' }
    end

    describe %(with "Won't Do") do
      let(:status) { Task::Statuses::WONT_DO }

      it { expect(color).to be == 'text' }
    end
  end

  describe '#task_type_icon' do
    let(:task_type) { nil }
    let(:icon)      { described_class.task_type_icon(task_type) }

    it 'should define the class method' do
      expect(described_class).to respond_to(:task_type_icon).with(1).argument
    end

    describe 'with nil' do
      it { expect(icon).to be == 'exclamation-triangle' }
    end

    describe 'with "Bugfix"' do
      let(:task_type) { Task::TaskTypes::BUGFIX }

      it { expect(icon).to be == 'bug' }
    end

    describe 'with "Chore"' do
      let(:task_type) { Task::TaskTypes::CHORE }

      it { expect(icon).to be == 'wrench' }
    end

    describe 'with "Epic"' do
      let(:task_type) { Task::TaskTypes::EPIC }

      it { expect(icon).to be == 'lightbulb' }
    end

    describe 'with "Feature"' do
      let(:task_type) { Task::TaskTypes::FEATURE }

      it { expect(icon).to be == 'gear' }
    end

    describe 'with "Investigation"' do
      let(:task_type) { Task::TaskTypes::INVESTIGATION }

      it { expect(icon).to be == 'search' }
    end

    describe 'with "Milestone"' do
      let(:task_type) { Task::TaskTypes::MILESTONE }

      it { expect(icon).to be == 'trophy' }
    end

    describe 'with "Release"' do
      let(:task_type) { Task::TaskTypes::RELEASE }

      it { expect(icon).to be == 'award' }
    end
  end
end
