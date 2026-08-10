class TalksController < ApplicationController
  PAGE_LIMIT = 24

  def index
    @pagy, @talks = pagy(:offset, Talk.order(:id), limit: PAGE_LIMIT)
  end
end
