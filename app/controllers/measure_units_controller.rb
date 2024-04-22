# frozen_string_literal: true

class MeasureUnitsController < ApplicationController
  load_and_authorize_resource

  def index
    @query, @measure_units = Common::Index.call(
      klass: MeasureUnit,
      params: params[:q],
      order: [created_at: :desc],
      accessible_by: current_ability
    )
  end

  def new
    @measure_unit = MeasureUnit.new
  end

  def create
    @measure_unit = MeasureUnit.new(measure_unit_params)

    if @measure_unit.save
      custom_redirect(path: measure_units_path, type: :success)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def measure_unit_params
    params.require(:measure_unit)
          .permit(:description, :abbreviation)
          .merge(enterprise: current_user.current_enterprise)
  end
end
