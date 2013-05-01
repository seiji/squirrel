module Squirrel::View
  class Base

    attr_reader :app
    attr_reader :window
    attr_reader :width
    attr_reader :height

    def initialize(app, x, y, width, height)
      @app = app

      @width = width
      @height = height

      @window = app.window.subwin(@height, @width, y, x)
      @window.scrollok(true)
      Ncurses.keypad(@window, true)
      @cur_y = 0
      @cur_x = 0
    end

    # control str
    def add_str(str, x, y, width=0, space=0)
      str = "-" unless str
      if width == 0
        width = str.length
      end
      @window.mvaddstr(y, x, str.display_slice(width).concat(" " * space))
      return x + width + space
    end

    def ins_str(str, x, y, width=0, space=0)
      if width == 0
        width = str.length
      end
      @window.mvinsstr(y, x, str.display_slice(width).concat(" " * space))
      return x + width + space
    end

    def clear
      @window.clear
      @window.noutrefresh
    end
    
    # control column width
    def width_data(column)
      width = 10
      type = column.type
      name = column.name
      dflt_value = column.dflt_value
      
      case type
      when "INTEGER", "FLOAT"
        width = 6
      when "TEXT"
        width = 100
      when "TIMESTAMP"
        width = 16
      when "VARCHAR"
        width = 20
      else
        case dflt_value
        when "CURRENT_TIMESTAMP"
          width = 16
        end
      end
      return width
    end

    def width_index(index)
      width = 20
      name = index.name

      width = [width, name.length].min
      return width
    end

    def incr_page
      check_page = @cur_page + 1
      check_page = @cur_page if check_page >= @pages.length
      @cur_page = check_page
    end

    def decr_page
      @cur_page -= 1
      @cur_page = 0 if @cur_page < 0
    end

    def display_menu
      @stdscr.clear
      @stdscr.move(0, 0)
      @stdscr.addstr(" rutt #{@menu}\n")
    end

    def move_pointer(pos, move_to=false)
      @stdscr.move(@cur_y, 0)
      @stdscr.addstr(" ")

      if move_to == true
        @cur_y = pos
      else
        @cur_y += pos
      end

      @stdscr.move(@cur_y, 0)
      @stdscr.addstr(">")
    end
  end
end
