module Squirrel::View
  class TableSelect

    def initialize(app)
      @app = app
      window = app.window
      @width = Ncurses.getmaxx(window) / 8
      @height = Ncurses.getmaxy(window) - 1
      
      @window = window.subwin(@height, @width, 1, 0)
      @window.scrollok(true)
      Ncurses.keypad(@window, true)

      @cur_y = 0
      @selected_index = 0
    end

    def show(index = 0)
      @window.move(@cur_y, 0)
      @items = Squirrel::Model.tables
      @items.each_with_index do |table, i|
        if (i == index)
          @selected_index = i
          @window.attron(Ncurses.COLOR_PAIR(1)|Ncurses::A_REVERSE)
        end
        @window.mvprintw i + @cur_y, 0, "  %-#{@width-2}s", table["name"]
        
        @window.attroff(Ncurses.COLOR_PAIR(1)| Ncurses::A_REVERSE)
        @window.noutrefresh
      end
      @app.right_pane.update(item)
    end

    def next
      new_index = @selected_index + 1
      new_index = @items.size - 1 if new_index >= @items.size
      show new_index
    end

    def prev
      new_index = @selected_index - 1
      new_index = 0 if new_index < 0
      show new_index
    end

    def item
      @items[@selected_index]
    end

  end
end
