class Calendar < ActiveRecord::Base
  ActiveRecord::Base.remove_connection
  self.table_name = 'calendar'
  ActiveRecord::Base.establish_connection({:adapter=>"mysql2", :username=>"root", :password=>"", :database=>"shot_v1", :pool=>5, :encoding=>"utf8", :host=>"localhost"})
end
