class EventSeriesController < ApplicationController
  def index
    @data_source = event_series_url(format: "json")
    @table_name = "event_series"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @event_series = EventSeries.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @event_series = EventSeries.new(event_series_params)
    if @event_series.save
      redirect_to event_series_url, :notice => "Successfully created event series."
    else
      render :new
    end
  end

  def edit
    @event_series = EventSeries.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @event_series = EventSeries.find(params[:id])
    if @event_series.update_attributes(params[:event_series])
      redirect_to event_series_url, :notice  => "Successfully updated event series."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def event_series_params
    params.require(:event_series).permit(:id, :frequency, :period, :starttime, :endtime, :all_day, :created_at, :updated_at, :user_id)
  end
end
