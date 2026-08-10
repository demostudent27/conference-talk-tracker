class SpeakersController < ApplicationController
  PAGE_LIMIT = 24

  def index
    @pagy, @speakers = pagy(:offset, Speaker.order(:id), limit: PAGE_LIMIT)
  end
end
