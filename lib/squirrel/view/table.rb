module Squirrel::View
  class Table

    attr_accessor :show_structure

    def initialize(app)
      window = app.window
      @show_structure = true
      
      @width = Ncurses.getmaxx(window) / 8 * 7
      @height = Ncurses.getmaxy(window) - 1
      
      @window = window.subwin(@height, @width, 1, Ncurses.getmaxx(window) / 8)
      @window.scrollok(true)
      Ncurses.keypad(@window, true)

      @cur_y = 0
      @selected_index = 0
    end

    def update(table)
      return unless table
      @table = table
      @window.clear
      @cur_y = 0

      @window.move(@cur_y, 0)

      name = table["name"]

      @columns = Squirrel::Model.table_info(name)

      unless show_structure
        @rows = Squirrel::Model.table_data(name)

        # 0
        @window.attron(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
        @window.mvprintw @cur_y, 0, "%-#{@width}s", "Data"
        @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)
        @cur_y += 1

        @window.attron(Ncurses.COLOR_PAIR(4))

        @columns.each_with_index do |column, j|
          column_name = column["name"]
          @window.mvprintw @cur_y, j *10, "%-10s", column_name
        end
        @window.attroff(Ncurses.COLOR_PAIR(4))
        @cur_y += 1        
        
        @rows.each_with_index do |row, i|
          @columns.each_with_index do |column, j|
            column_name = column["name"]
            @window.mvprintw i + @cur_y, j * 10, "%-10s", row[column_name]
          end
        end
      else
        @indices = Squirrel::Model.table_index(name)
        
        # 0
        @window.attron(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
        @window.mvprintw @cur_y, 0, "%-72s", "Columns"
        @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)
        
        @window.attron(Ncurses.COLOR_PAIR(2)|Ncurses::A_REVERSE)
        @window.mvprintw @cur_y, 72 + 4, "%-#{@width - 76}s", "Index"
        @window.attroff(Ncurses.COLOR_PAIR(2)| Ncurses::A_REVERSE)
        @cur_y += 1
        
        # 1
        columns_header = %w(cid name type notnull dflt_value pk)
        @window.attron(Ncurses.COLOR_PAIR(4))
        @window.mvprintw @cur_y, 0, "%3s %-24s %-14s %-7s %-14s %-5s", *columns_header
        @window.attroff(Ncurses.COLOR_PAIR(4))
        
        @indices.each_with_index do |index, i|
          @window.mvprintw @cur_y, 72 + 4 + i * 30, "%-30s", index["name"]
        end
        
        @cur_y += 1
        
        # 2 -
        @columns.each_with_index do |row, i|
          @window.mvprintw i + @cur_y, 0, "%3d %-24s %-14s %-7s %-14s %-5s",
          row["cid"],
          row["name"], 
          row["type"],
          row["notnull"] == 1 ? "true" : "false",
          row["dflt_value"],
          row["pk"] == 1 ? "true" : "false"
          
          @indices.each_with_index do |index, j|
            is_index_column = false
            index_columns = Squirrel::Model.index_info(index["name"])
            index_columns.each do |index_column|
              if row["name"] == index_column["name"]
                is_index_column = true
            end
            end
            if is_index_column
            @window.attron(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
            end
            @window.mvprintw i + @cur_y, 72 + 4 + j * 30, "%-30s", is_index_column ? "" : "-"
            @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)
          end
        end

      end
      @window.noutrefresh
    end

    def show_header
      Ncurses.attron(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @stdscr.mvprintw @cur_y, 0, " " * @width
      Ncurses.attroff(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE) 

      @cur_y += 1
    end

    def show_database
      db_list = Squirrel::Model.database_list
      main_db = db_list[0]

      @stdscr.move(@cur_y, 0)
      Ncurses.attron(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @stdscr.addch(Ncurses::ACS_BLOCK)
      @stdscr.addstr " Databases"
      @stdscr.addstr " " * (@width - 11)
      Ncurses.attroff(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @cur_y += 1

      @stdscr.move(@cur_y, 0)      
      @stdscr.addstr "%5d" % main_db["seq"]
      @stdscr.addch(Ncurses::ACS_VLINE)
      @stdscr.addstr " %-10s" % main_db["name"]
      @stdscr.addch(Ncurses::ACS_VLINE)
      @stdscr.addstr " %-100s" % main_db["file"]
      @cur_y += 1

      @stdscr.move(@cur_y, 0)
      Ncurses.attron(Ncurses.COLOR_PAIR(11))
      @stdscr.addstr("-" * @width)
      Ncurses.attroff(Ncurses.COLOR_PAIR(11)) 
      @cur_y += 1
    end

    def show_tables
      @cur_y += 1

      @stdscr.move(@cur_y, 0)
      Ncurses.attron(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @stdscr.addch(Ncurses::ACS_BLOCK)
      @stdscr.addstr " Tables"
      @stdscr.addstr " " * (@width - 11)
      Ncurses.attroff(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @cur_y += 1

      @stdscr.move(@cur_y, 0)
      Squirrel::Model.tables.each_with_index do |table, i|
        
        @stdscr.mvprintw i + @cur_y, 0, "* %s", table["name"]
      end
      @cur_y += 10
      
      @stdscr.move(@cur_y, 0)
      Ncurses.attron(Ncurses.COLOR_PAIR(11))
      @stdscr.addstr("-" * @width)
      Ncurses.attroff(Ncurses.COLOR_PAIR(11)) 
      @cur_y += 1
    end

  end
end
