require "./navigator"

# TODO: Once the core functionality is down, rework with better design
# practices...

module Marbles
  class Interpreter
    def initialize(lines : Array(String))
      @nav = Navigator.new lines
      @values = {} of Char => (String | Int32)
      @in_quote = false
      @string = ""
      @marble = 0
    end

    def run
      unless (@nav.find 'V').size == 1
        STDERR.puts "Program does not a single entry point."
      end
      start = (@nav.find 'V')[0]
      @nav.goto start[0], start[1]

      until @nav.done
        current = @nav.down.as Char
        unless current.ascii_whitespace?
          handle current
        end
      end
    end

    def next_number
      position = @nav.position
      builtnum = ""

      loop do
        break if @nav.done
        current = @nav.down.as Char
        next if current.ascii_whitespace?

        if !current.to_i? && builtnum == "" && @values.has_key? current
          builtnum = @values[current].as Int32
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

    def next_string
      return ""
    end

    def handle(command : Char)
      case command
      when '\\'
        @nav.right
      when '/'
        begin
          @nav.left
        rescue
          STDERR.puts "Redirected into a wall!"
          exit -1
        end
      when '+'
        @marble += next_number
      when '-'
        @marble -= next_number
      when 'P'
        puts next_string
      when 'M'
        puts @marble
      when 'R'
        exit next_number
      end
    end
  end
end
