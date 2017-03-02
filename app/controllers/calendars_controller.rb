class CalendarsController < ApplicationController
  def index
    @data_source = calendars_url(format: "json")
    @table_name = "calendar"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @calendar = Calendar.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @calendar = Calendar.new(calendar_params)
    if @calendar.save
      redirect_to calendars_url, :notice => "Successfully created calendar."
    else
      render :new
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update_attributes(params[:calendar])
      redirect_to calendars_url, :notice  => "Successfully updated calendar."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def calendar_params
    params.require(:calendar).permit(:id, :job_name, :event_name, :all_day, :start_dt, :end_date, :user_id, :created_at, :startMeridiem, :endMeridiem, :bgcolor)
  end
end
