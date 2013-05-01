module Squirrel::View
  class Header < Base

    def initialize(app)
      super app, 0, 0, app.width, 1
    end

    def show
      @window.move(@cur_y, 0)

      @window.attron(Ncurses.COLOR_PAIR(14)|Ncurses::A_REVERSE)
      
      @window.mvprintw 0, 0, "%s", $path

#      @window.addstr "hogehoge #{@width}"
      
      @window.attroff(Ncurses.COLOR_PAIR(14)|Ncurses::A_REVERSE)
      @window.noutrefresh
    end
  end
end
