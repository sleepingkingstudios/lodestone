# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

require 'support/examples/models'

module Spec::Support::Examples::Models
  module ValidationExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    module ClassMethods
      # :nocov:
      def extract_message(maybe_hash, default)
        return default unless maybe_hash.is_a?(Hash)

        maybe_hash.fetch(:message, default)
      end

      def normalize_attribute_type(value)
        return nil if value.nil?

        return value.name.underscore if value.is_a?(Class)

        value.to_s
      end
      # :nocov:
    end

    shared_examples 'should validate the format of' \
    do |attr_name, **options|
      matching    = options.fetch(:matching, [])
      nonmatching = options.fetch(:nonmatching, %w[xyzzy])
      message     = options.fetch(:message, 'is invalid')

      matching.each do |value|
        value, desc =
          if value.is_a?(Array)
            value
          else
            # :nocov:
            [value, value]
            # :nocov:
          end

        context "when #{attr_name} is #{desc}" do
          let(:attributes) { super().merge(attr_name => value) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end
      end

      nonmatching.each do |value|
        value, desc =
          if value.is_a?(Array)
            value
          else
            # :nocov:
            [value, value]
            # :nocov:
          end

        context "when #{attr_name} is #{desc}" do
          let(:attributes) { super().merge(attr_name => value) }

          it 'should have an error' do
            expect(subject).to have_errors.on(attr_name).with_message(message)
          end
        end
      end
    end

    shared_examples 'should validate the inclusion of' \
    do |attr_name, **options|
      message = options.fetch(:message, 'is not included in the list')
      values  = options.fetch(:in)

      context "when #{attr_name} is an invalid value" do
        let(:attributes) { super().merge(attr_name => Object.new) }

        it 'should have an error' do
          expect(subject).to have_errors.on(attr_name).with_message(message)
        end
      end

      values.each do |value|
        context "when #{attr_name} is #{value}" do
          let(:attributes) { super().merge(attr_name => value) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end
      end
    end

    # :nocov:
    shared_examples 'should validate the numericality of' \
    do |attr_name, **options|
      extend ClassMethods

      message = options.fetch(:message, 'is not a number')

      context "when #{attr_name} is not a number" do
        let(:attributes) { super().merge(attr_name => 'not a number') }

        it 'should have an error' do
          expect(subject).to have_errors.on(attr_name).with_message(message)
        end
      end

      if options[:greater_than_or_equal_to]
        gte_count   = options[:greater_than_or_equal_to]
        gte_message = extract_message(
          options[:greater_than_or_equal_to],
          "must be greater than or equal to #{gte_count}"
        )

        context "when #{attr_name} is less than #{gte_count}" do
          let(:attributes) { super().merge(attr_name => (gte_count - 1)) }

          it 'should have an error' do
            expect(subject)
              .to have_errors.on(attr_name).with_message(gte_message)
          end
        end

        context "when #{attr_name} is equal to #{gte_count}" do
          let(:attributes) { super().merge(attr_name => gte_count) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end

        context "when #{attr_name} is greater than #{gte_count}" do
          let(:attributes) { super().merge(attr_name => (gte_count + 1)) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end
      end

      if options[:less_than_or_equal_to]
        lte_count   = options[:less_than_or_equal_to]
        lte_message = extract_message(
          options[:less_than_or_equal_to],
          "must be less than or equal to #{lte_count}"
        )

        context "when #{attr_name} is less than #{lte_count}" do
          let(:attributes) { super().merge(attr_name => (lte_count - 1)) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end

        context "when #{attr_name} is equal to #{lte_count}" do
          let(:attributes) { super().merge(attr_name => lte_count) }

          it 'should not have an error' do
            expect(subject).not_to have_errors.on(attr_name)
          end
        end

        context "when #{attr_name} is greater than #{lte_count}" do
          let(:attributes) { super().merge(attr_name => (lte_count + 1)) }

          it 'should have an error' do
            expect(subject)
              .to have_errors.on(attr_name).with_message(lte_message)
          end
        end
      end

      if options[:only_integer]
        integer_message =
          extract_message(options[:only_integer], 'must be an integer')

        context "when #{attr_name} is not an integer" do
          let(:attributes) { super().merge(attr_name => 3.14) }

          it 'should have an error' do
            expect(subject)
              .to have_errors.on(attr_name).with_message(integer_message)
          end
        end
      end
    end
    # :nocov:

    shared_examples 'should validate the presence of' \
    do |attr_name, message: nil, type: nil|
      extend ClassMethods

      attr_type = normalize_attribute_type(type)
      message ||= "can't be blank"

      context "when #{attr_name} is nil" do
        let(:attributes) { super().merge(attr_name => nil) }

        it 'should have an error' do
          expect(subject).to have_errors.on(attr_name).with_message(message)
        end
      end

      if attr_type == 'string'
        context "when #{attr_name} is empty" do
          let(:attributes) { super().merge(attr_name => '') }

          it 'should have an error' do
            expect(subject).to have_errors.on(attr_name).with_message(message)
          end
        end
      end
    end

    shared_examples 'should validate the uniqueness of' \
    do |attr_name, attributes: {}|
      injected_attributes = attributes

      context "when a #{described_class} exists with the same #{attr_name}" do
        let(:value)        { subject.send(attr_name) }
        let(:message)      { 'has already been taken' }
        let(:factory_name) do
          return super() if defined?(super())

          described_class.name.split('::').last.underscore.intern
        end

        before do
          attributes =
            FactoryBot
            .attributes_for(factory_name)
            .merge(injected_attributes)
            .merge(attr_name.intern => value)

          described_class.create!(attributes)
        end

        it 'should have an error' do
          expect(subject).to have_errors.on(attr_name).with_message(message)
        end
      end
    end

    # :nocov:
    shared_examples 'should validate the scoped uniqueness of' \
    do |attr_name, scope:, attributes: {}|
      context "when a #{described_class} exists with the same #{attr_name}" do
        let(:value)   { subject.send(attr_name) }
        let(:message) { 'has already been taken' }

        scoped_contexts =
          scope.reduce([{}]) do |ary, (attribute, values)|
            values
              .map do |value|
                ary.dup.map { |hsh| hsh.merge(attribute => value) }
              end
              .flatten
          end
        tools = SleepingKingStudios::Tools::Toolbelt.instance

        scoped_contexts.each do |scope_attributes|
          attributes_list =
            scope_attributes
            .map do |scope_attribute, scope_value|
              "#{scope_attribute}: #{scope_value.inspect}"
            end

          context "with #{tools.array_tools.humanize_list(attributes_list)}" do
            before do
              described_class.create!(
                attributes
                  .merge(attr_name => value)
                  .merge(scope_attributes)
              )
            end

            # rubocop:disable RSpec/ExampleLength
            # rubocop:disable RSpec/MultipleExpectations
            it 'should check the scope' do
              scopes_match =
                scope_attributes
                .reduce(true) do |memo, (scope_attribute, scope_value)|
                  memo && subject.send(scope_attribute) == scope_value
                end

              if scopes_match
                expect(subject)
                  .to have_errors
                  .on(attr_name)
                  .with_message(message)
              else
                expect(subject).not_to have_errors.on(attr_name)
              end
            end
            # rubocop:enable RSpec/ExampleLength
            # rubocop:enable RSpec/MultipleExpectations
          end
        end
      end
    end
    # :nocov:
  end
end
