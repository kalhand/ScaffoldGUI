class PostsController < ApplicationController
  def index
    @data_source = posts_url(format: "json")
    @table_name = "posts"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @post = Post.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_url, :notice => "Successfully created post."
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to posts_url, :notice  => "Successfully updated post."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:id, :posts_reason, :posts_title, :posts_description, :posts_hierarchy, :is_active, :posted_by, :updated_by, :post_type, :posted_at, :created_at, :updated_at, :assign_to, :anonymous_post, :issue_tracker, :posts_aots)
  end
end
