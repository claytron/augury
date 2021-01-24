# frozen_string_literal: true

module Augury
  class TwitterConfigError < StandardError
    def message
      'No twitter credential configuration found in the augury config'
    end
  end

  class TransformError < StandardError
    def message
      'Augury transforms are invalid, check your configuration'
    end
  end
end
