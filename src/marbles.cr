require "./marbles/*"

module Marbles
  prg = Interpreter.new(%w{V

                           +
                           6
                           +
                           4
                           M

                           R
                           0})
  prg.run
end
