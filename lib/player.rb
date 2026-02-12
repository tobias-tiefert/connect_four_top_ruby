# frozen_string_literal: true

require_relative 'token'
# require_relative 'board'

# class that represents the players in the connect_four game
class Player
  attr_reader :name, :color

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def next_move
    loop do
      puts "#{@name} what column do you choose?"
      column = gets.chomp.to_i - 1
      return column unless column > 7 || @board.column_full?(column)

      puts 'Please choose an available column'
    end
  end
end
