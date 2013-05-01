module Squirrel::View
  class CommandLine < Base

    def initialize(app)
      super app, 0, app.height - 1, app.width, 1
    end

    def update(str= "")
      @window.clear
      @window.move(@cur_y, 0)
      ins_str(str, 0, 0, @width-1)
      @window.noutrefresh
    end
  end
end
