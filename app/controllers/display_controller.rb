class DisplayController < ApplicationController

  layout 'home'
   def index
     colors = %w[orange yellow green red purple blue grey]
     @list_models_data = []
   
    @list_models_data
  end

  def edit
  end

  def download_data
    model = params[:table].to_s.classify.constantize
    data = model.pluck
    data.unshift(model.column_names)
    response.headers['Content-Disposition'] = "attachment; filename=#{params['table'].to_s}.csv"
    render :text => csv_data(data), :content_type => 'text/csv'
  end
  
  def master_reports_count
    data = {'name' => 'Master Reports', 'count' => 17}
    render :json => data
    #respond_to do |format|
    #  format.json
    #end
  end

  def cruds_count
    data = {'name' => 'CRUDS', 'count' => 20}
    render :json => data
  end
  

  
  def user_cruds
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection({:adapter=>"mysql2", :username=>"root", :password=>"", :database=>"", :pool=>5, :encoding=>"utf8", :host=>"localhost"})
    user_email = params['email'] ? params['email'] : 'kalhan.d@gmail.com'
    user_crud_dbs = UserCrud.where(:email => user_email).pluck(:db_name).uniq
    result = []
    user_crud_dbs.each do |db|
      temp_result = {}
      temp_result[:name] = db
      temp_result[:y] = UserCrud.where(:email => user_email).where(:db_name => db).count
      temp_result[:cruds] = crud_data(UserCrud.where(:email => user_email).where(:db_name => db))
      result << temp_result
    end
    render :json => result
  end
  private

  def csv_data(data)
  require 'csv'
    CSV.generate do |csv|
      data.each do |d|
        csv << d
      end
    end
  end

  def crud_data(cruds)
    result = []
    cruds.each do |c|
      temp_result = {}
      temp_result[:id] = c.db_name
      temp_result[:name] = c.crud_name
      temp_result[:url] = "//localhost/"+c.crud_link
     # temp_result[:y] = c.crud_name.classify.constantize.count
      temp_result[:y] = c.count
      result << temp_result
    end
    result
  end

end
