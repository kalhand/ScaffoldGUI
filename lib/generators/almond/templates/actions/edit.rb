  def edit
    @<%= instance_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end

  end
