require 'thor'
require 'ncursesw'
require 'sqlite3'

module Squirrel
  class CLI < Thor::Group
    argument :path, :type => :string, :desc => "path of sqlite db"

    def initialize(*args)
      super
      
    end

    def start
      $db = SQLite3::Database.new(path)
      $db.results_as_hash = true
      $path = path
      
      stdscr = Ncurses.initscr()
      Ncurses.start_color();
      Ncurses.cbreak();
      Ncurses.noecho();
      Ncurses.keypad(stdscr, true);
      Ncurses.curs_set 0        # if possible

      Ncurses.init_pair 1, Ncurses::COLOR_RED,   Ncurses::COLOR_WHITE
      Ncurses.init_pair 2, Ncurses::COLOR_GREEN, Ncurses::COLOR_WHITE
      Ncurses.init_pair 3, Ncurses::COLOR_BLUE,  Ncurses::COLOR_WHITE
      Ncurses.init_pair 4, Ncurses::COLOR_CYAN,  Ncurses::COLOR_WHITE
      Ncurses.init_pair 5, Ncurses::COLOR_YELLOW,  Ncurses::COLOR_WHITE

      Ncurses.init_pair 11, Ncurses::COLOR_BLUE,   Ncurses::COLOR_BLACK
      Ncurses.init_pair 12, Ncurses::COLOR_RED,   Ncurses::COLOR_BLACK
      Ncurses.init_pair 13, Ncurses::COLOR_CYAN,  Ncurses::COLOR_BLACK
      Ncurses.init_pair 14, Ncurses::COLOR_YELLOW,  Ncurses::COLOR_BLACK

      stdscr.clear

      screen = Squirrel::App.new(stdscr)
      screen.loop

    ensure
      Ncurses.endwin()
    end
  end
end
