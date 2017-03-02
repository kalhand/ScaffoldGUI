class <%= class_name %> < ActiveRecord::Base
<%= "  ActiveRecord::Base.remove_connection" %>
<%= "  self.table_name = '#{table_name}'\n" if table_name -%>
<%= "  ActiveRecord::Base.establish_connection(#{db_config})\n" -%>
end
