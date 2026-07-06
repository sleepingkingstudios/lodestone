# frozen_string_literal: true

module ApplicationHelper # rubocop:disable Style/Documentation
  # Converts flash messages to alerts format.
  def normalize_alerts(flash) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
    flash.to_hash.each.with_object([]) do |(key, value), alerts|
      next if value.blank?

      case key
      when :alert, 'alert'
        key = 'warning'
      when :notice, 'notice'
        key = 'info'
      end

      (value.is_a?(Array) ? value : [value]).each do |item|
        item = { message: item } unless item.is_a?(Hash)

        alerts << item.merge(type: key.to_s).transform_keys(&:to_sym)
      end
    end
  end
end
