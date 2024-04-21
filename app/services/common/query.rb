# frozen_sring_literal: true

module Common
  class Query < Base
    def initialize(includes: nil, joins: nil, order: nil, accessible_by: nil, page: nil, **args)
      super(**args)
      self.includes = includes
      self.joins = joins
      self.order = order
      self.accessible_by = accessible_by
      self.page = page
    end

    def call
      query
    end

    private

    def query
      @query ||= klass.includes(includes)
                      .joins(joins)
                      .order(order)
                      .accessible_by(accessible_by)
                      .page(page)
                      .ransack(params)
    end

    attr_accessor :includes, :joins, :order, :accessible_by, :page
  end
end
