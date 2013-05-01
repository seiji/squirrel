module Squirrel::View

  class TableRow < Base

    def initialize(view)
      @view = view
      @width  = view.app.width / 8 * 7
      offset = 13
      @height = view.app.height - 3 - (offset -1)

      @window = view.window.subwin(@height, @width, offset, view.app.width / 8)
      @window.scrollok(false)
      Ncurses.keypad(@window, false)
      @cur_y = 0
      @cur_x = 0
    end

    def update(columns, row)
      @window.clear
      x, y = 0, 0
      @window.attron(Ncurses.COLOR_PAIR(2) | Ncurses::A_REVERSE)
      add_str("Detail", x, y, @width)
      @window.attroff(Ncurses.COLOR_PAIR(2)| Ncurses::A_REVERSE)

      x, y = 0, 1
      columns.each_with_index do |column, i|
        x = 0
        column_name = column.name
        @window.attron(Ncurses.COLOR_PAIR(13))
        x = add_str("#{column_name}", x, y, 20, 1)
        @window.attroff(Ncurses.COLOR_PAIR(13))

        value = row[column_name] || " "
        value = value.to_s
        value.each_line do |line|
          add_str(line, x, y, @width, 1)
          y += 1
        end

      end
      @window.noutrefresh
    end

    def remove
      Ncurses.delwin(@window)
    end
  end
end
