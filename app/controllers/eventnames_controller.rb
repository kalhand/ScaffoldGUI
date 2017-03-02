class EventnamesController < ApplicationController
  def index
    @data_source = eventnames_url(format: "json")
    @table_name = "eventname"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @eventname = Eventname.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @eventname = Eventname.new(eventname_params)
    if @eventname.save
      redirect_to eventnames_url, :notice => "Successfully created eventname."
    else
      render :new
    end
  end

  def edit
    @eventname = Eventname.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @eventname = Eventname.find(params[:id])
    if @eventname.update_attributes(params[:eventname])
      redirect_to eventnames_url, :notice  => "Successfully updated eventname."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def eventname_params
    params.require(:eventname).permit(:id, :job_name, :event_name, :date_time, :user_id)
  end
end
