class WelcomeController < ApplicationController
  #skip_before_filter :verify_session, :only => [:not_authorised, :session_destroy]

  def index
    #session[:user] = params[:email] if params[:email]
  end
@db;
  def dbcredentials
    host = params[:host].strip
    adapter = params[:adapter].strip
    db = params[:db].strip
    username = params[:username].strip
    password = params[:password].strip
    session[:db] = db
    session[:adapter] = adapter
    old_connection = ActiveRecord::Base.remove_connection
    begin 
    new_connection = ActiveRecord::Base.establish_connection(
      adapter:  adapter,
      host:     host,
      username: username,
      password: password,
      database: db
    )
    @tables = ActiveRecord::Base.connection.tables
    #rescue ActiveRecord::NoDatabaseError
    #  redirect_to "/welcome", :notice => "Invalid Credentials" and return
    rescue ActiveRecord::NoDatabaseError
      redirect_to '/welcome', :notice => 'Invalid Credentials' and return
   rescue 
      redirect_to '/welcome', :notice => 'Invalid Credentials' and return
    end
   redirect_to "/tablelisting"
  end

  def tablelisting
  @dbTable = session[:db]
  @adapter = session[:adapter]  
   # @tables = ActiveRecord::Base.connection.tables
	#@tables = MasterGdi.find_by_sql("SHOW FULL TABLES IN gdioperations WHERE TABLE_TYPE LIKE '%TABLE%'") 
  #raise @adapter
  if @adapter == 'postgresql'
      @tables = Welcome.connection.execute("SELECT tablename FROM pg_catalog.pg_tables where schemaname='public'") 
      print @tables
  else
	    @tables = Welcome.connection.execute("SHOW FULL TABLES IN #{@dbTable} WHERE TABLE_TYPE LIKE '%TABLE%'")
  end
	  session[:db]=''
    session[:adapter]=''
  end

  def table_info
    @table = params[:table].strip
    
    @table_info = ActiveRecord::Base.connection.columns(@table)
    @routes= Rails.application.routes.routes.map do |route|
  #{alias: route.name, path: route.path.spec.to_s, controller: route.defaults[:controller], action: route.defaults[:action]}
end
  end

   def create_crud
    #raise params.inspect
    db_config = ActiveRecord::Base.connection_config
    #raise db_config.inspect 
    @scaffold = params[:table].strip
    @table_info = Welcome.connection.columns(@scaffold)
    @colms = @table_info.map {|c| [c.name,c.type.to_s,params[c.name]]}
    #@colums = @table_info.map {|c| c.name + ":" + c.type.to_s + " "}.join(" ")
    @colms = @colms.map {|c| c.flatten.compact}
    @for_scaff = @colms.map {|c| c.join(":")}.join(" ")
    #ActiveRecord::Base.connection.query_cache.clear
    #raise db_config[:database].inspect
    #raise @for_scaff.inspect
    #@table_info = ActiveRecord::Base.connection.columns(@scaffold)
    #@colums = @table_info.map {|c| c.name + ":" + c.type.to_s + " "}.join(" ")
   # system "rails g scaffold #{@scaffold} #{@colums}--skip-migration --no-stylesheets --skip"
   now = Time.now.to_i
  # UserCrud.create(:crud_name => @scaffold, :crud_link => @scaffold.pluralize.underscore, :db_name => db_config[:database], :email => session[:user])
   #user_crud = UserCrud.new
   #user_crud.email = session['user']
   #user_crud.crud_name = @scaffold
   #user_crud.crud_link = @scaffold.pluralize.underscore
   #user_crud.db_name = db_config[:database]
   #user_crud.bundle_name = now.to_s + '-' + crud_name
   #user_crud.save
   #raise user_crud.inspect
    system "rails g almond #{@scaffold} #{@for_scaff} --database-name=#{db_config[:database]} --username=#{db_config[:username]} --password=#{db_config[:password]} --host=#{db_config[:host]} --now=#{now} --force"


  #  model_file_name = @scaffold.singularize.underscore
  #  database_config = ActiveRecord::Base.connection_config 
  #  model = <<-CODE
#	class #{model_file_name.classify} < ActiveRecord::Base
#		self.table_name = '#{@scaffold}'
 #               #{database_config}
  #              ActiveRecord::Base.establish_connection(#{database_config})
#	end
 #   CODE

   #File.open(Rails.root + "app/models/#{model_file_name.chomp('s')}.rb", 'w+') {|f| f.write(model) }
   
   # redirect_to "/controller_list"
   redirect_to "/#{@scaffold.pluralize.underscore}"
   #  redirect_to "/my_cruds"
  end

def controller_list
   # @listcontrollers = Dir[Rails.root.join('app/controllers/*_controller.rb')].map { |path|(path.match(/(\w+)_controller.rb/); $1).camelize}  
     @listcontrollers = Dir[Rails.root.join('app/controllers/*_controller.rb')].map { |path| path.match(/(\w+)_controller.rb/); $1 }.compact

end

def mst_controller_list
   # @listcontrollers = Dir[Rails.root.join('app/controllers/*_controller.rb')].map { |path|(path.match(/(\w+)_controller.rb/); $1).camelize}  
     @listcontrollers = Dir[Rails.root.join('app/controllers/gdi_mst*.rb')].map { |path| path.match(/(\w+)_controller.rb/); $1 }.compact

end

 def msttablelisting
   

   # @tables = ActiveRecord::Base.connection.tables
	@tables = Welcome.connection.execute("SHOW FULL TABLES IN gdioperations WHERE TABLE_TYPE LIKE '%TABLE%'") 
	#@tables = Welcome.connection.execute("SHOW FULL TABLES IN #{@dbTable} WHERE TABLE_TYPE LIKE '%TABLE%'")
	  
  end
  
  def draw_graph
   model = params['model'].constantize
   
  end
  
  def not_authorised
  end

  def session_destroy
    session[:user] = nil
    redirect_to '/'    
  end
 
end
