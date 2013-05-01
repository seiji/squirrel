require "ostruct"

module Squirrel
  class Model

    def self.query(query_string)
      cols = $db.prepare(query_string).columns

      items = []
      begin
        $db.results_as_hash = true
        $db.execute query_string do |row|
          item = {}
          cols.each do |column|
            item[column] = row[column]
          end

          items << OpenStruct.new(item)
        end
      rescue SQLite3::SQLException => e
        e.message
      end
      items
    end
    
    
    def self.database_list
      $db.execute(%Q{PRAGMA database_list;})
    end

    def self.tables
      query(%Q{
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
      query(%Q{PRAGMA table_info(#{table_name});})
    end

    def self.table_index(table_name)
      query(%Q{
SELECT * FROM sqlite_master 
WHERE tbl_name='#{table_name}' and type='index'
ORDER BY name
      })
    end

    def self.table_data(table_name)
      $db.execute(%Q{SELECT * FROM '#{table_name}' })
    end

    def self.index_info(index_name)
      $db.execute(%Q{
PRAGMA index_info(#{index_name});
      })
    end

    def self.table_count(table_name)
      query(%Q{SELECT COUNT(*) as count FROM '#{table_name}' })[0].count
    end

  end
end
