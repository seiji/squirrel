module Squirrel::View

  class TableData
    def initialize(view)
      @view = view
      @window = view.window
      @selected_index = -1
      @window.scrollok(false)
      Ncurses.keypad(@window, false)

    end

    def update(table)
      @table = table
      columns = Squirrel::Model.table_info(table.name)
      rows = Squirrel::Model.table_data(table.name)
      @items = rows
      
      x, y = 0, 0
      @window.attron(Ncurses.COLOR_PAIR(3) | Ncurses::A_REVERSE)
      @view.add_str("Data", x, y, @view.width)
      @window.attroff(Ncurses.COLOR_PAIR(3)| Ncurses::A_REVERSE)

      x, y = 0, 1
      @window.attron(Ncurses.COLOR_PAIR(13))
      columns.each_with_index do |column, j|
        column_name = column.name
        width_col = @view.width_data(column)
        x = @view.add_str(column_name, x, y, width_col, 1)
      end
      @window.attroff(Ncurses.COLOR_PAIR(13))

      x, y = 0, 2
      rows.each_with_index do |row, i|
        x = 0
        columns.each_with_index do |column, j|
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
      new_index = @items.size - 1 if new_index >= @items.size
      select new_index
    end

    def prev
      new_index = @selected_index - 1
      new_index = 0 if new_index < 0
      select new_index
    end

    private
    def select(index = 0)
      x, y = 0, 2
      columns = Squirrel::Model.table_info(@table.name)
      rows = Squirrel::Model.table_data(@table.name)
      @items = rows
      rows.each_with_index do |row, i|
        x = 0
        if (i == index)
          @selected_index = i
          @window.attron(Ncurses.COLOR_PAIR(1)|Ncurses::A_REVERSE)
        end
        columns.each_with_index do |column, j|
          column_name = column.name
          width_col = @view.width_data(column)
          if (x + width_col < @view.width)
            x = @view.add_str(row[column_name].to_s, x, i + y, width_col, 1)
          end
        end
        x = @view.add_str(" ", x, i + y, @view.width - x)
        @window.attroff(Ncurses.COLOR_PAIR(1)| Ncurses::A_REVERSE)
      end
      open_row columns, index
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
