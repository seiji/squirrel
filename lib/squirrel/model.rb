module Squirrel
  class Model

    def self.database_list
      $db.execute(%Q{PRAGMA database_list;})
    end

    def self.tables
      $db.execute(%Q{
SELECT * FROM sqlite_master 
WHERE type='table'
ORDER BY name
      }) 
    end

    def self.all_table
      $db.execute(%Q{
SELECT name FROM
   (SELECT * FROM sqlite_master UNION ALL
    SELECT * FROM sqlite_temp_master)
WHERE type='table'
ORDER BY name
      }) 
    end

    def self.table_info(table_name)
      $db.execute(%Q{PRAGMA table_info(#{table_name});})
    end

    def self.table_index(table_name)
      $db.execute(%Q{
SELECT * FROM sqlite_master 
WHERE tbl_name='#{table_name}' and type='index'
ORDER BY name
      })
    end

    def self.table_data(table_name)
      $db.execute(%Q{
SELECT * FROM '#{table_name}' 
})
    end

    def self.index_info(index_name)
      $db.execute(%Q{
PRAGMA index_info(#{index_name});
      })
    end

  end
end
