module Squirrel::View
  class Header < Base

    def initialize(app)
      super app, 0, 0, app.width, 1
    end

    def show
      @window.move(@cur_y, 0)
      @window.attron(Ncurses.COLOR_PAIR(14))
      add_str($path, 0, 0, $path.size)
      @window.attroff(Ncurses.COLOR_PAIR(14))
      @window.noutrefresh
    end
  end
end
