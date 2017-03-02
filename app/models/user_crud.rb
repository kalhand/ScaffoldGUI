class UserCrud < ActiveRecord::Base
#  self.table_name = 'user_cruds'
 # ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection({:adapter=>"mysql2", :username=>"root", :password=>"", :database=>"", :pool=>5, :encoding=>"utf8", :host=>"localhost"})
 
 # validates :crud_link, uniqueness: {scope: [:db_name, :email]}
  #validate :valid_crud_link

#  def valid_crud_link
    
 # end

end
