  def new
    @<%= instance_name %> = <%= class_name %>.new
    respond_to do |format|
      format.js {render 'layouts/edit.js.erb'}
    end
  end
