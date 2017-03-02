class JobsController < ApplicationController
  def index
    @data_source = jobs_url(format: "json")
    @table_name = "job"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @job = Job.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_url, :notice => "Successfully created job."
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      redirect_to jobs_url, :notice  => "Successfully updated job."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def job_params
    params.require(:job).permit(:id, :job_name, :date_time, :user_id)
  end
end
