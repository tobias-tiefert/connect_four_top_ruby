require_relative 'lib/token'
require_relative 'lib/board'
require_relative 'lib/player'

board = Board.new

puts <<~HEREDOC
  Puts HEREDOC Board:

     \e[103m\e[30m ♞ \e[105m ♞ \e[103m ♘ \e[105m ♘ \e[103m \e[97m ♞ \e[105m ♞ \e[103m \e[105m \e[0m
     \e[100m\e[30m ♞ \e[107m ♞ \e[100m ♘ \e[107m ♘ \e[100m \e[97m ♞ \e[107m\e[100m\e[107m  ♞  \e[0m
     \e[100m\e[34m ♞ \e[107m ♞ \e[100m ♘ \e[107m ♘ \e[100m \e[35m ♞ \e[107m\e[100m\e[107m  ♞  \e[0m
     \e[100m\e[30m ♞ \e[103m ♞ \e[100m ♘ \e[103m ♘ \e[100m \e[97m ♞ \e[103m\e[100m\e[103m  ♞  \e[0m
HEREDOC

puts 'drawn board'

board.draw_board
board.drop_token(Token.new('blue'), 4)
board.drop_token(Token.new('yellow'), 4)
board.drop_token(Token.new('blue'), 4)
board.drop_token(Token.new('yellow'), 4)
board.draw_board
board.drop_token(Token.new('blue'), 4)
board.drop_token(Token.new('yellow'), 4)
board.drop_token(Token.new('blue'), 2)
board.drop_token(Token.new('yellow'), 1)
board.drop_token(Token.new('blue'), 2)
board.draw_board
