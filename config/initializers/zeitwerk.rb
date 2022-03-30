# frozen_string_literal: true

require 'actions'
require 'models'

loader = Rails.autoloaders.main

loader.push_dir(Rails.root.join('lib/actions'), namespace: Actions)
loader.push_dir(Rails.root.join('lib/models'), namespace: Models)
