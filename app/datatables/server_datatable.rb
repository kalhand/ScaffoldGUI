class ServerDatatable
  delegate :params, :link_to, to: :@view

  def initialize(view, controller_name)
    @view = view
    @controller_name = controller_name
    @model_name = controller_name.classify.constantize
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @model_name.count,
      iTotalDisplayRecords: results.total_entries,
      aaData: data
    }
  end

private

  def data
    final_data = results.pluck
    final_data.each do |result|
      result.unshift(link_to("Edit","#{@controller_name}/#{result.first}/edit", remote: true, :class => 'edit_page'))
    end
    #results.each_with_index do |result,i|
     # rr[i].push(link_to("Edit","/#{@controller_name}/#{result.id}/edit"))
    #end
   final_data
  end

  def results
    @results ||= fetch_results
  end

  def fetch_results
    results = @model_name.order("#{sort_column} #{sort_direction}")
    results = results.page(page).per_page(per_page)
    searchable_columns = @model_name.column_names
    search_columns_query = searchable_columns.join(" like :search or ") + " like :search"
    if params[:sSearch].present?
      results = results.where(search_columns_query, search: "%#{params[:sSearch]}%")
    end
    results
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    return  @model_name.count if ( params[:iDisplayLength] && params[:iDisplayLength].to_i < 0)
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = @model_name.column_names
    #params[:iSortCol_0] = params[:iSortCol_0].to_i + 1
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
