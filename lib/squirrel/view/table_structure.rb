module Squirrel::View
  class TableStructure
    def initialize(view)
      @view = view
      @window = view.window
    end

    def update(table)
      columns = Squirrel::Model.table_info(table.name)
      indices = Squirrel::Model.table_index(table.name)

      x, y = 0, 0
      @window.attron(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
      x = @view.add_str("Columns", 0, y, 76, 2)
      @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)

      @window.attron(Ncurses.COLOR_PAIR(2)|Ncurses::A_REVERSE)
      x = @view.add_str("Index", x, y, @view.width - 76)
      @window.attroff(Ncurses.COLOR_PAIR(2)| Ncurses::A_REVERSE)

      x, y = 0, 1
      columns_header = %w(cid name type notnull dflt_value pk)
      @window.attron(Ncurses.COLOR_PAIR(13))
      str = "%3s %-24s %-14s %-7s %-18s %-5s" % columns_header
      x = @view.add_str(str, x, y, 76, 2)
      @window.attroff(Ncurses.COLOR_PAIR(13))

      index_x = x
      indices.each_with_index do |index, i|
        width = @view.width_index(index)
        x = @view.add_str(index.name, x, y, width, 1)
      end

      x, y = 0, 2
      columns.each_with_index do |column, i|
        x = 0
        x = @view.add_str(column.cid.to_s, x, i + y, 3, 1)
        x = @view.add_str(column.name, x, i + y, 24, 1) 
        x = @view.add_str(column.type, x, i + y, 14, 1)
        x = @view.add_str(column.notnull == 1 ? "true" : "false", x, i + y, 7, 1)
        x = @view.add_str(column.dflt_value, x, i + y, 18, 1)
        x = @view.add_str(column.pk == 1 ? "true" : "false", x, i + y, 5, 1)

        x += 1
        indices.each_with_index do |index, j|
          is_index_column = false
          index_columns = Squirrel::Model.index_info(index.name)
          index_columns.each do |index_column|
            if column.name == index_column["name"]
              is_index_column = true
            end
          end
          if is_index_column
            @window.attron(Ncurses.COLOR_PAIR(12))
          end
          width = @view.width_index(index)
          x = @view.add_str(is_index_column ? "*" : "-", x, y + i, width, 1)
          @window.attroff(Ncurses.COLOR_PAIR(12))
        end
      end
    end # end update

    def enter
    end

    def exit
    end

    def next
    end

    def prev
    end

  end
end
