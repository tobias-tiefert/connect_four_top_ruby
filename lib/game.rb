# frozen_string_literal: true

require_relative 'token'
require_relative 'board'
require_relative 'player'
# class that represents the game in the connect_four game
class Game
  def initialize
    @board = Board.new
    @players = [
      Player.new('Player 1', 'yellow', @board),
      Player.new('Player 2', 'blue', @board)
    ]
    @current_player = @players[0]
    @winner = nil
  end

  def start_game
    play until game_over?
    result
  end

  def play
    @board.draw_board
    token = input_token
    update_winner(token)
    switch_players
  end

  def input_token
    token = Token.new(@current_player.color)
    column = @current_player.next_move
    @board.drop_token(token, column)
    token.all_neighbours(@board.positions)
    token
  end

  def update_winner(token)
    @winner = @current_player if token.connect_four?
    @winner = false if @board.full?
  end

  def game_over?
    @winner.nil? ? false : true
  end

  def switch_players
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def result
    @board.draw_board
    message = @winner == false ? "It's a draw, the board is full" : "#{@winner.name} wins the game"
    puts message
  end
end
