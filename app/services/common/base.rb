# frozen_string_literal: true

module Common
  class Base < ApplicationService
    def initialize(klass:, params:)
      self.klass = klass
      self.params = params
    end

    private

    attr_accessor :klass, :params
  end
end
