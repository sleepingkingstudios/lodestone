# frozen_string_literal: true

require 'rails_helper'

require 'support/examples/model_examples'

RSpec.describe Project, type: :model do
  include Spec::Support::Examples::ModelExamples

  subject(:project) { described_class.new(attributes) }

  let(:attributes) do
    {
      active:       true,
      description:  "It's a rocket. Hopefully one that goes to the moon.",
      name:         'Moon Rocket',
      project_type: Project::ProjectTypes::APPLICATION,
      public:       true,
      repository:   'example.com/projects/moon-rocket',
      slug:         'moon-rocket'
    }
  end

  describe '::ProjectTypes' do
    let(:expected_types) do
      {
        APPLICATION: 'application',
        LIBRARY:     'library',
        SCRIPT:      'script'
      }
    end

    include_examples 'should define immutable constant', :ProjectTypes

    it 'should enumerate the types' do
      expect(described_class::ProjectTypes.all).to be == expected_types
    end

    describe '::APPLICATION' do
      it 'should store the value' do
        expect(described_class::ProjectTypes::APPLICATION)
          .to be == 'application'
      end
    end

    describe '::LIBRARY' do
      it 'should store the value' do
        expect(described_class::ProjectTypes::LIBRARY)
          .to be == 'library'
      end
    end

    describe '::SCRIPT' do
      it 'should store the value' do
        expect(described_class::ProjectTypes::SCRIPT)
          .to be == 'script'
      end
    end
  end

  include_examples 'should define primary key'

  include_examples 'should define slug'

  include_examples 'should define timestamps'

  describe '#active' do
    include_examples 'should define attribute', :active, default: true
  end

  describe '#description' do
    include_examples 'should define attribute', :description, default: ''
  end

  describe '#name' do
    include_examples 'should define attribute', :name, default: ''
  end

  describe '#project_type' do
    include_examples 'should define attribute', :project_type, default: ''
  end

  describe '#public' do
    include_examples 'should define attribute', :public, default: true
  end

  describe '#repository' do
    include_examples 'should define attribute', :repository, default: ''
  end

  describe '#tasks' do
    include_examples 'should define reader', :tasks, []

    context 'when the project has many tasks' do
      let(:tasks) { Array.new(3) { FactoryBot.build(:task, project: project) } }

      before(:example) { tasks.each(&:save!) }

      it { expect(project.tasks).to match_array(tasks) }
    end
  end

  describe '#valid?' do
    it { expect(project).not_to have_errors }

    include_examples 'should validate the presence of', :active

    include_examples 'should validate the presence of',
      :description,
      type: String

    include_examples 'should validate the presence of',
      :name,
      type: String

    include_examples 'should validate the inclusion of',
      :project_type,
      in:      described_class::ProjectTypes.all.values,
      message: 'must be application, library, or script'

    include_examples 'should validate the presence of',
      :project_type,
      type: String

    include_examples 'should validate the presence of', :public
  end
end
