module Squirrel::View
  class StatusLine < Base

    def initialize(app)
      super app, 0, app.height - 2, app.width, 1
    end

    def update (str="")
      @window.move(@cur_y, 0)
      @window.attron(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
      add_str(str, 0, 0, @width -1)
      @window.attroff(Ncurses.COLOR_PAIR(3)|Ncurses::A_REVERSE)
      @window.noutrefresh
    end
  end
end
