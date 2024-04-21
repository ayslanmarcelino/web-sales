# frozen_string_literal: true

module Common
  class Index < Query
    def call
      [query, result]
    end

    private

    def result
      @result ||= query.result
    end
  end
end
