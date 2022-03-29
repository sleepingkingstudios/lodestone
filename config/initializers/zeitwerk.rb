# frozen_string_literal: true

require 'models'

loader = Rails.autoloaders.main

loader.push_dir(Rails.root.join('lib/models'), namespace: Models)
