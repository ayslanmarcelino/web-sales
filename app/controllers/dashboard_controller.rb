class DashboardController < ApplicationController
  def index; end

  def pdf
    render(
      pdf: 'file',
      layout: 'application',
      template: 'dashboard/report'
      # show_as_html: true
    )
  end
end
