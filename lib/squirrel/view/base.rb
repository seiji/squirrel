module Squirrel::View
  class Base

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

    def draw_str(str, x, y, width=0, space=0)
      if width == 0
        width = str.length
      end
      
      @window.mvaddstr(y, x, str.display_slice(width).concat(" " * space))
      return x + width + space
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
