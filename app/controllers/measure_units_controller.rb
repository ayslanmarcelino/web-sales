# frozen_string_literal: true

class MeasureUnitsController < ApplicationController
  def index
    @query, @measure_units = Common::Index.call(
      klass: MeasureUnit,
      params: params[:q],
      order: [created_at: :desc],
      accessible_by: current_ability
    )
  end
end
