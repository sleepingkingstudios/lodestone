# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  subject(:helpers) { Class.new.include(described_class).new }

  describe '#normalize_alerts' do
    deferred_examples 'should normalize the alert' do
      describe 'when the alert value is a String' do
        let(:alerts) { { type => 'Something went wrong' } }
        let(:expected) do
          [
            {
              message: 'Something went wrong',
              type:    type.to_s
            }
          ]
        end

        it { expect(helpers.normalize_alerts(flash)).to be == expected }
      end

      describe 'when the alert value is an Array of Strings' do
        let(:alerts) do
          { type => ['Radiation alert', 'Meltdown in progress'] }
        end
        let(:expected) do
          [
            {
              message: 'Radiation alert',
              type:    type.to_s
            },
            {
              message: 'Meltdown in progress',
              type:    type.to_s
            }
          ]
        end

        it { expect(helpers.normalize_alerts(flash)).to be == expected }
      end

      describe 'when the alert value is a Hash' do
        let(:alerts) do
          { type => { icon: 'radiation', message: 'Something went wrong' } }
        end
        let(:expected) do
          [
            {
              icon:    'radiation',
              message: 'Something went wrong',
              type:    type.to_s
            }
          ]
        end

        it { expect(helpers.normalize_alerts(flash)).to be == expected }
      end

      describe 'when the alert value is an Array of Hashes' do
        let(:alerts) do
          {
            type => [
              { icon: 'radiation', message: 'Radiation alert' },
              { message: 'Meltdown in progress' }
            ]
          }
        end
        let(:expected) do
          [
            {
              icon:    'radiation',
              message: 'Radiation alert',
              type:    type.to_s
            },
            {
              message: 'Meltdown in progress',
              type:    type.to_s
            }
          ]
        end

        it { expect(helpers.normalize_alerts(flash)).to be == expected }
      end
    end

    let(:alerts) { {} }
    let(:flash) do
      instance_double(ActionDispatch::Flash::FlashHash, to_hash: alerts)
    end

    it { expect(helpers).to respond_to(:normalize_alerts).with(1).argument }

    context 'when there are no alerts' do
      let(:expected) { [] }

      it { expect(helpers.normalize_alerts(flash)).to be == expected }
    end

    context 'when there is an alert with key :alert' do
      let(:alerts) { { alert: 'Something went wrong' } }
      let(:expected) do
        [
          {
            message: 'Something went wrong',
            type:    'warning'
          }
        ]
      end

      it { expect(helpers.normalize_alerts(flash)).to be == expected }
    end

    context 'when there is an alert with key :notice' do
      let(:alerts) { { notice: 'Something went wrong' } }
      let(:expected) do
        [
          {
            message: 'Something went wrong',
            type:    'info'
          }
        ]
      end

      it { expect(helpers.normalize_alerts(flash)).to be == expected }
    end

    context 'when there is an alert with key :danger' do
      let(:type) { :danger }

      include_deferred 'should normalize the alert'
    end

    context 'when there is an alert with key :error' do
      let(:type) { :error }

      include_deferred 'should normalize the alert'
    end

    context 'when there is an alert with key :info' do
      let(:type) { :info }

      include_deferred 'should normalize the alert'
    end

    context 'when there is an alert with key :success' do
      let(:type) { :success }

      include_deferred 'should normalize the alert'
    end

    context 'when there is an alert with key :warning' do
      let(:type) { :warning }

      include_deferred 'should normalize the alert'
    end
  end
end
