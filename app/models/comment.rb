	class Comment < ActiveRecord::Base
		self.table_name = 'comments'
                {:adapter=>"mysql2", :host=>"localhost", :username=>"root", :password=>"", :database=>"shot_v1"}
                ActiveRecord::Base.establish_connection({:adapter=>"mysql2", :host=>"localhost", :username=>"root", :password=>"", :database=>"shot_v1"})
	end
