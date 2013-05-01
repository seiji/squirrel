module Squirrel::View

  class TableData
    def initialize(view)
      @view = view
      @window = view.window
      @selected_index = 0
      @scroll_offset = 0

      @window.scrollok(true)
      Ncurses.keypad(@window, false)

    end

    def update(table)
      @table = table
      @columns = Squirrel::Model.table_info(table.name)
      rows = Squirrel::Model.table_data(table.name)
      @items = rows
      
      x, y = 0, 0
      @window.attron(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @view.add_str("Data", x, y, @view.width)
      @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)

      x, y = 0, 1
      @window.attron(Ncurses.COLOR_PAIR(13))
      @columns.each_with_index do |column, j|
        column_name = column.name
        width_col = @view.width_data(column)
        x = @view.add_str(column_name, x, y, width_col, 1)
      end
      @window.attroff(Ncurses.COLOR_PAIR(13))

      x, y = 0, 2
      rows.each_with_index do |row, i|
        x = 0
        @columns.each_with_index do |column, j|
          column_name = column.name
          width_col = @view.width_data(column)
          if (x + width_col < @view.width)
            x = @view.add_str(row[column_name].to_s, x, i + y, width_col, 1)
          end
        end
      end
    end

    def enter
      select
    end

    def exit
      if @subview
        @subview.remove
      end
      @view.update(@table)
    end

    def next
      new_index = @selected_index + 1
      if new_index >= @items.size
        new_index = @items.size - 1
        return false
      end
      if new_index > 9
        scroll 1
      end
      select new_index
      return true
    end

    def prev
      new_index = @selected_index - 1
      if new_index < 0
        new_index = 0
        return false
      end
      if new_index > 9 - 1
        scroll -1
        update_row(0, @items[@scroll_offset])
      end
      @view.app.status_line.update "#{@scroll_offset}"
      select new_index
      return true
    end

    private
    def select(new_index = 0)
      old_index = @selected_index
      @selected_index = new_index

      update_row(old_index - @scroll_offset, @items[old_index])
      update_row(new_index - @scroll_offset, @items[new_index])
      open_row @columns, new_index
    end

    def update_row(index = 0, row)
      return if index > @view.height

      x, y = 0, 2
      if index == @selected_index - @scroll_offset
        @window.attron(Ncurses.COLOR_PAIR(1)|Ncurses::A_REVERSE)
      end
      @columns.each_with_index do |column, j|
        column_name = column.name
        width_col = @view.width_data(column)
        if (x + width_col < @view.width)
          x = @view.add_str(row[column_name].to_s, x, index + y, width_col, 1)
        end
      end
      x = @view.add_str(" ", x, index + y, @view.width - x)
      @window.attroff(Ncurses.COLOR_PAIR(1)| Ncurses::A_REVERSE)
    end
    
    def scroll(line)
      Ncurses.wscrl(@window, line)
#      Ncurses.wrefresh(@window)
      @window.noutrefresh

      @scroll_offset += line
    end

    def open_row(columns, index)
      item = @items[index]
      return unless item
      
      unless @subview
        @subview = Squirrel::View::TableRow.new(@view)
      end
      @subview.update columns, item
    end
    
  end
end
