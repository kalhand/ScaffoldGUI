class MbddThread < ActiveRecord::Base
 ActiveRecord::Base.establish_connection(
      adapter:  'mysql2',
      host:     'localhost',
      username: 'root',
      password: '',
      database: 'lportal'
    )

self.table_name = 'MBThread'

end
