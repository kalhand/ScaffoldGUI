  def index
    @data_source = <%= items_url %>(format: "json")
    @table_name = "<%= name %>"
    respond_to do |format|
      format.html
      format.json { render json: ServerDatatable.new(view_context,controller_name) }
    end
  end
