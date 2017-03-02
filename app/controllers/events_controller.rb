class EventsController < ApplicationController
  def index
    @data_source = events_url(format: "json")
    @table_name = "events"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_url, :notice => "Successfully created event."
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to events_url, :notice  => "Successfully updated event."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def event_params
    params.require(:event).permit(:id, :posts_reason, :posts_title, :posts_description, :is_active, :posted_by, :updated_by, :post_type, :posted_at, :created_at, :updated_at, :assign_to, :anonymous_post, :all_day, :event_series_id, :starttime, :endtime, :posts_aots)
  end
end
