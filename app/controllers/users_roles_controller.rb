class UsersRolesController < ApplicationController
  before_action :set_users_role, only: [:show, :edit, :update, :destroy]

  # GET /users_roles
  def index
    @data_source = users_roles_url(format: "json")
    @table_name = controller_name.classify.constantize.table_name
    respond_to do |format|
     format.html
     format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  # GET /users_roles/1
  def show
  end

  # GET /users_roles/new
  def new
    @users_role = UsersRole.new
    respond_to do |format|
      format.js {render 'edit.js.erb'}
    end
  end

  # GET /users_roles/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /users_roles
  def create
    @users_role = UsersRole.new(users_role_params)

    if @users_role.save
      redirect_to @users_role, notice: 'Users role was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users_roles/1
  def update
    if @users_role.update(users_role_params)
      redirect_to @users_role, notice: 'Users role was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users_roles/1
  def destroy
    @users_role.destroy
    redirect_to users_roles_url, notice: 'Users role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_role
      @users_role = UsersRole.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def users_role_params
      params.require(:users_role).permit(:roleId, :userId)
    end
end
