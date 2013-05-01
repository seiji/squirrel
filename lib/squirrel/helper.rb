class String 

  def display_slice(len = 0)
    if len <= 0
      return self
    end

    str = ""
    i = 0
    self.each_char do |c|
      screen_size = 0
      if c.bytesize > 2
        screen_size = 2
      else
        screen_size = 1
      end
      if i + screen_size > len
        break
      end
      i += screen_size
      str << c
    end
    return str.concat(" " * (len - i))
  end
end
