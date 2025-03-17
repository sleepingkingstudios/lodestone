# frozen_string_literal: true

require 'rails_helper'

require 'cuprum/rails/rspec/deferred/controller_examples'

RSpec.describe BoardsController, type: :controller do
  include Cuprum::Rails::RSpec::Deferred::ControllerExamples

  describe '.repository' do
    include_examples 'should define class reader',
      :repository,
      -> { an_instance_of(Cuprum::Rails::Records::Repository) }
  end

  describe '.resource' do
    let(:resource) { described_class.resource }

    include_examples 'should define class reader',
      :resource,
      -> { an_instance_of(Librum::Core::Resources::BaseResource) }

    it { expect(resource.name).to be == 'board' }

    it { expect(resource.singular?).to be true }
  end

  include_deferred 'should respond to format',
    :html,
    using: Cuprum::Rails::Responders::Html::Resource

  include_deferred 'should define action',
    :show,
    Cuprum::Rails::Action,
    command_class: Boards::Commands::Show,
    member:        false
end
