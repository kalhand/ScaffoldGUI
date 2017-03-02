class CommentsController < ApplicationController
  def index
    @data_source = comments_url(format: "json")
    @table_name = "comments"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end

  def new
    @comment = Comment.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to comments_url, :notice => "Successfully created comment."
    else
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to comments_url, :notice  => "Successfully updated comment."
    else
      render :edit
    end
  end

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:id, :comments, :post_id, :created_by, :updated_by, :is_active, :anonymous_comment, :created_at, :updated_at, :refer_to)
  end
end
