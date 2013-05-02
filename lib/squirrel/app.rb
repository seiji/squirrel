module Squirrel

  class App
    attr_reader :window
    attr_reader :width
    attr_reader :height
    
    attr_reader :table_pane
    attr_reader :status_line
    attr_reader :command_line
    
    def initialize(window)
      @window = window
      @width = Ncurses.getmaxx(@window)
      @height = Ncurses.getmaxy(@window)
      Ncurses.leaveok(@window, true)
      
      @header = Squirrel::View::Header.new(self)

      @left_pane  = Squirrel::View::ListTable.new(self)
      @table_pane = Squirrel::View::Table.new(self)
      @status_line = Squirrel::View::StatusLine.new(self)
      @command_line = Squirrel::View::CommandLine.new(self)

      
      @focus_table = false
    end

    def down
      if @focus_table
        @table_pane.next
      else
        @left_pane.next
      end
    end

    def up
      if @focus_table
        @table_pane.prev
      else
        @left_pane.prev
      end
    end

    def quit
      if @focus_table
        @focus_table = false
        @table_pane.exit
      else
        @command_line.update "Quit? (Y/n)"
        ch = @window.getch
        case ch.chr
        when /Y/
          return true
        end
        @command_line.clear
      end
      return false
    end

    def loop
      @cur_y = 0
      @window.clear
      @header.show
      @left_pane.show

      while true do
        @command_line.clear
        c = @window.getch

        if c > 0 and c < 255
          case c.chr
          when /j/i
            down
          when /k/i
            up
          when /q/i
            break if quit()
          else
            case c
            when 9              # tab
              @table_pane.show_structure = !@table_pane.show_structure
              @table_pane.update(@left_pane.item)
            when 10             # Enter
              unless @focus_table
                @focus_table = @table_pane.enter
              end
            when 120            # M-x
              Ncurses.echo()
              while((ch= @command_line.window.getch) != 7) # M-g
              end
              Ncurses.noecho()
              @command_line.clear
            end
          end
        else
          case c
          when Ncurses::KEY_DOWN
            down
          when Ncurses::KEY_UP
            up
          end
        end
        
      end
    end

  end
end
