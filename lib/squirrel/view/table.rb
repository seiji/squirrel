module Squirrel::View

  class Table < Base
    attr_accessor :show_structure

    def initialize(app)
      super app, app.width / 8, 1, app.width / 8 * 7, app.height - 3
      @show_structure = false
      @selected_index = 0
    end

    def update(table)
      return unless table

      @table = table
      @window.clear
      @window.move(@cur_y, 0)

      @delegate = nil
      unless show_structure
        @delegate = Squirrel::View::TableData.new(self)
      else
        @delegate = Squirrel::View::TableStructure.new(self)
      end
      @delegate.update table
      @window.noutrefresh

      @table_count = Squirrel::Model.table_count(table.name)
      @app.status_line.update("Count: #{@table_count}")
    end

    def enter
      if @table_count > 0
        @delegate.enter
      end
      @window.noutrefresh
      return @table_count > 0
    end

    def exit
      @delegate.exit
      @window.noutrefresh
    end

    def next
      if @delegate.next
        @window.noutrefresh
      end
    end

    def prev
      if @delegate.prev
        @window.noutrefresh
      end
    end

  end
end
