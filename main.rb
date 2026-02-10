require_relative 'lib/game'

puts <<~HEREDOC
  Puts HEREDOC Board:

     \e[103m\e[30m ♞ \e[105m ♞ \e[103m ♘ \e[105m ♘ \e[103m \e[97m ♞ \e[105m ♞ \e[103m \e[105m \e[0m
     \e[100m\e[30m ♞ \e[107m ♞ \e[100m ♘ \e[107m ♘ \e[100m \e[97m ♞ \e[107m\e[100m\e[107m  ♞  \e[0m
     \e[100m\e[34m ♞ \e[107m ♞ \e[100m ♘ \e[107m ♘ \e[100m \e[35m ♞ \e[107m\e[100m\e[107m  ♞  \e[0m
     \e[100m\e[30m ♞ \e[103m ♞ \e[100m ♘ \e[103m ♘ \e[100m \e[97m ♞ \e[103m\e[100m\e[103m  ♞  \e[0m
HEREDOC

game = Game.new
game.start_game
