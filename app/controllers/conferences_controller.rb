class ConferencesController < ApplicationController
  PAGE_LIMIT = 24

  before_action :set_conference, only: %i[show edit update destroy]
  before_action :set_return_to, only: %i[new create edit update destroy]

  def index
    @pagy, @conferences = pagy(:offset, Conference.order(:id), limit: PAGE_LIMIT)
  end

  def show
  end

  def new
    @conference = Conference.new
  end

  def create
    @conference = Conference.new(create_conference_params)
    if @conference.save
      redirect_to conference_path(@conference), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @conference.update(update_conference_params)
      redirect_to conference_path(@conference), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @conference.destroy!
    redirect_to @return_to, status: :see_other
  end

  private

  def set_conference
    @conference = Conference.find(params[:id])
  end
  
  def set_return_to
    expected = case action_name
    when "new", "create"
      "foundation:mutation-record:show"
    when "edit", "update"
      conference_path(@conference)
    when "destroy"
      conferences_path
    end
    candidate = params.fetch(:return_to, expected)
    @return_to = candidate if valid_return_to?(candidate, expected)
    raise ActionController::BadRequest, "invalid return destination" unless @return_to
  
    @cancel_to = case action_name
    when "new", "create"
      conferences_path
    when "edit", "update"
      @return_to
    end
  end
  
  def valid_return_to?(candidate, expected)
    if expected == "foundation:mutation-record:show"
      candidate == expected
    else
      url_from(candidate) == expected
    end
  end
  
  def create_conference_params
    params.expect(conference: %i[name venue])
  end
  
  def update_conference_params
    params.expect(conference: %i[name venue])
  end
end
