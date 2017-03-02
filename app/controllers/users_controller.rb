class UsersController < ApplicationController
  def index
    @data_source = users_url(format: "json")
    @table_name = "users"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_url, :notice => "Successfully created user."
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_url, :notice  => "Successfully updated user."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:id, :attuid, :shot_user_name, :shot_user_email, :is_admin, :is_active, :created_at, :created_by, :updated_at, :updated_by)
  end
end
