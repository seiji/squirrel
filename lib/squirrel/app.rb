module Squirrel

  class App
    attr_reader :window
    attr_reader :width
    attr_reader :height
    
    attr_reader :right_pane
    
    def initialize(window)
      @window = window
      @width = Ncurses.getmaxx(@window)
      @height = Ncurses.getmaxy(@window)

      @header = Squirrel::View::Header.new(self)
      @left_pane  = Squirrel::View::TableSelect.new(self)
      @right_pane = Squirrel::View::Table.new(self)
      
    end

    def display_menu
      @window.clear
      @window.move(0, 0)
      @window.addstr(" rutt #{@menu}\n")
    end

    def move_pointer(pos, move_to=false)
      @window.move(@cur_y, 0)
      @window.addstr(" ")

      if move_to == true
        @cur_y = pos
      else
        @cur_y += pos
      end

      @window.move(@cur_y, 0)
      @window.addstr(">")
    end

    def loop
      @cur_y = 0
      @window.clear
      @header.show
      @left_pane.show
#      move_pointer(0)

      while true do
        c = @window.getch
        if c > 0 and c < 255
          case c.chr
          when /j/i
            @left_pane.next
          when /k/i
            @left_pane.prev
          when /q/i
            break
          else
            case c
            when 9              # tab
              @right_pane.show_structure = !@right_pane.show_structure
              @right_pane.update(@left_pane.item)
            end
          end
        else
        end
      end
    end

  end
end
