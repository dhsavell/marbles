require "./marbles/*"

module Marbles
  if ARGV.size > 0
    if File.readable? ARGV[0]
      Interpreter.new(File.read_lines ARGV[0]).run
    end
  end
end
