module Marbles
  class Navigator
    def initialize(@lines : Array(String))
      @x = 0
      @y = 0
    end

    def find(value : Char)
      matches = Array(Tuple(Int32, Int32)).new
      @lines.size.times do |index|
        if @lines[index].index value
          matches << {index, @lines[index].index(value) || -1}
        end
      end

      return matches
    end

    def goto(coords : {Int32, Int32})
      goto coords[0], coords[1]
    end

    def goto(row : Int32, column : Int32)
      if column >= 0 && row >= 0 && row < @lines.size
        @x = column
        @y = row
      else
        raise Exception.new("Out of bounds!")
      end
    end

    def position
      return {@y, @x}
    end

    def current
      return @lines[@y][@x]
    rescue
      return nil
    end

    def up
      if @y - 1 >= 0
        @y -= 1
        return @x >= @lines[@y].size ? ' ' : @lines[@y][@x]
      end

      return nil
    end

    def down
      if @y + 1 < @lines.size
        @y += 1
        return @x >= @lines[@y].size ? ' ' : @lines[@y][@x]
      end

      return nil
    end

    def done
      return @y + 1 >= @lines.size
    end

    def left
      if @x - 1 >= 0
        @x -= 1
        return @lines[@y][@x]
      end

      return nil
    end

    def right
      @x += 1
      return @x >= @lines[@y].size ? ' ' : @lines[@y][@x]
    end
  end
end
