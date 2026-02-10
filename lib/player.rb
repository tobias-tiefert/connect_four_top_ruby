# frozen_string_literal: true

require_relative 'token'
# require_relative 'board'

# class that represents the players in the connect_four game
class Player
  attr_reader :name

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def next_move
    puts 'what column do you choose?'
    column = gets.chomp
    token = Token.new(@color)
    @board.drop_token(token, column)
  end
end
