	class UsersRole < ActiveRecord::Base
		self.table_name = 'Users_Roles'
                {:adapter=>"mysql2", :host=>"localhost", :username=>"root", :password=>"", :database=>"user"}
                ActiveRecord::Base.establish_connection({:adapter=>"mysql2", :host=>"localhost", :username=>"root", :password=>"", :database=>"user"})
	end
