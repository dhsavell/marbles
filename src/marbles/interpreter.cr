require "./navigator"

# TODO: Once the core functionality is down, rework with better design
# practices...

module Marbles
  class Interpreter
    def initialize(lines : Array(String))
      @nav = Navigator.new lines
      @values = {} of Char => Int32
      @marble = 0
    end

    def run
      unless (@nav.find 'V').size == 1
        STDERR.puts "Program does not have a single entry point."
        exit -1
      end
      start = (@nav.find 'V')[0]
      @nav.goto start

      until @nav.done
        current = @nav.down.as Char
        unless current.ascii_whitespace?
          handle current
        end
      end
    end

    def next_var
      current = ' '
      while current.ascii_whitespace?
        break if @nav.done
        current = @nav.down.as Char
        if current == '\\'
          @nav.right
          next
        elsif current == '/'
          @nav.left
          next
        end
      end

      if current.lowercase?
        return current
      else
        STDERR.puts "Variable name must be lowercase."
        exit -1
      end
    end

    def next_string
      builtstr = ""
      current = ' '

      until current == '"'
        break if @nav.done
        current = @nav.down.as Char
      end

      loop do
        break if @nav.done
        current = @nav.down.as Char
        break if current == '"'
        builtstr += current
      end

      @nav.up
      return builtstr
    end

    def next_number
      position = @nav.position
      builtnum = ""

      loop do
        break if @nav.done
        current = @nav.down.as Char
        next if current.ascii_whitespace?

        if current == '\\'
          @nav.right
          next
        elsif current == '/'
          @nav.left
          next
        end


        if !current.to_i? && builtnum == "" && @values.has_key? current
          builtnum = "#{@values[current]}"
          break
        end

        if current.to_i?
          builtnum += current
        elsif !current.to_i? && builtnum == ""
          builtnum = "1"
          break
        else
          break
        end
      end

      @nav.goto position
      return builtnum.to_i
    end

    def next_expression
      first = next_number
      current = ' '

      while current.ascii_whitespace?
        break if @nav.done
        current = @nav.down.as Char
      end

      op = @nav.down.as Char
      second = next_number

      case op
      when 'G'
        return first > second
      when 'L'
        return first < second
      when 'N'
        return first != second
      when 'E'
        return first == second
      end

      return false
    end

    def next_input
      value = " "

      until value.to_i?
        value = gets.as String
        value = value.chomp
      end

      return value.to_i
    end

    def handle(command : Char)
      case command
      when '\\'
        @nav.right
      when '/'
        begin
          @nav.left
        rescue
          STDERR.puts "Redirected into a wall! #{@nav.position}"
          exit -1
        end
      when '+' # Add
        @marble += next_number
      when '-' # Subtract
        @marble -= next_number
      when 'P' # Print
        puts next_string
      when 'M' # print Marble
        puts @marble
      when 'C' # marble to Character
        puts @marble.chr
      when 'A' # Assign
        @values[next_var] = next_number
      when 'L' # Load
        nv = next_var
        @marble = (@values.has_key? nv) ? @values[nv] : 0
      when 'S' # Save marble into variable
        @values[next_var] = @marble
      when 'R' # Return
        exit next_number
      when '^' # Conditional
        value = next_expression
        if value
          @nav.right
        else
          @nav.left
        end
      when '?'
        nv = next_var
        @values[nv] = Random.rand next_number
      when 'I'
        @values[next_var] = next_input
      when '%'
        target = next_number
        pos = @nav.position
        if (@nav.find '%').size > 0
          (@nav.find '%').each do |coords|
            puts coords
            @nav.goto coords
            val = next_number
            puts val
            break if val == target
          end
        else
          @nav.goto pos
        end
      end
    end
  end
end
