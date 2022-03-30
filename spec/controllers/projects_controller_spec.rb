# frozen_string_literal: true

require 'rails_helper'

require 'support/contracts/controller_contracts'

RSpec.describe ProjectsController, type: :controller do
  include Spec::Support::Contracts::ControllerContracts

  describe '.resource' do
    subject(:resource) { described_class.resource }

    let(:permitted_attributes) do
      %w[
        active
        description
        name
        project_type
        public
        repository
        slug
      ]
    end

    it { expect(resource).to be_a Cuprum::Rails::Resource }

    it { expect(resource.default_order).to be :name }

    it { expect(resource.permitted_attributes).to be == permitted_attributes }

    it { expect(resource.resource_class).to be == Project }
  end

  include_contract 'should define action',
    :create,
    Actions::Projects::Create,
    member: false

  include_contract 'should define action',
    :destroy,
    Cuprum::Rails::Actions::Destroy,
    member: true

  include_contract 'should define action',
    :edit,
    Cuprum::Rails::Actions::Edit,
    member: true

  include_contract 'should define action',
    :index,
    Cuprum::Rails::Actions::Index,
    member: false

  include_contract 'should define action',
    :new,
    Cuprum::Rails::Actions::New,
    member: false

  include_contract 'should define action',
    :show,
    Cuprum::Rails::Actions::Show,
    member: true

  include_contract 'should define action',
    :update,
    Cuprum::Rails::Actions::Update,
    member: true
end
