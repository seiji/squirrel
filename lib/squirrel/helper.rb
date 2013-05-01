class String 
  def display_slice(len = 0)
    if len <= 0
      return self
    end

    str = ""
    i = 0
    self.each_char do |c|
      str << c
      if c.bytesize > 2
        i += 2
      else 
        i += 1
      end
      if i >= len
        break
      end
    end
    len = i if i > len
    return str.concat(" " * (len - i))
  end
end
