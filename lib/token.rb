# frozen_string_literal: true

DIRECTIONS = {
  up: { x: 0, y: 1, opposite: :down },
  up_right: { x: 1, y: 1, opposite: :down_left },
  right: { x: 1, y: 0, opposite: :left },
  down_right: { x: 1, y: -1, opposite: :up_left },
  down: { x: 0, y: -1, opposite: :up },
  down_left: { x: -1, y: -1, opposite: :up_right },
  left: { x: -1, y: 0, opposite: :right },
  up_left: { x: -1, y: 1, opposite: :down_right }
}.freeze

COLOR_OPTIONS = {
  'green' => "\e[92m◉\e[90m",
  'blue' => "\e[94m◉\e[90m",
  'yellow' => "\e[93m◉\e[90m",
  'red' => "\e[91m◉\e[90m",
  'purple' => "\e[95m◉\e[90m",
  'white' => "\e[107m◉\e[90m"
}.freeze

# the token objects for the connect_four game
class Token
  attr_accessor :position
  attr_reader :color, :neighbours, :sign

  def initialize(color = 'white')
    @color = color
    @position = nil
    @neighbours = {
      up: nil,
      up_right: nil,
      right: nil,
      down_right: nil,
      down: nil,
      down_left: nil,
      left: nil,
      up_left: nil
    }
    @directions = DIRECTIONS
    @sign = create_sign(@color)
  end

  def on_the_board?(x_position, y_position)
    x_position.between?(0, 6) && y_position.between?(0, 5)
  end

  def create_sign(color = 'white')
    COLOR_OPTIONS[color].nil? ? "\e[107m◉\e[90m" : COLOR_OPTIONS[color]
  end

  def neighbour(object, direction)
    @neighbours[direction] = object
  end

  def all_neighbours(positions)
    @directions.each do |direction|
      neighbour_token = neighbour_token(direction, positions)
      next if neighbour_token.nil?

      neighbour_token.neighbour(self, direction[1][:opposite])
      neighbour(neighbour_token, direction[0])
    end
  end

  def connect_four?
    @directions.each do |direction|
      break if direction[0] == :down

      result = find_direction(direction[0])
      return result if result
    end
    false
  end

  protected

  def find_tokens(direction, result = 0)
    neighbour_token = @neighbours[direction]

    return result if neighbour_token.nil? || neighbour_token.color != @color

    result += 1
    neighbour_token.find_tokens(direction, result)
  end

  private

  def neighbour_token(direction, positions)
    target_x = @position[:x] + direction[1][:x]
    target_y = @position[:y] + direction[1][:y]
    return nil unless on_the_board?(target_x, target_y) && positions[target_x][target_y].nil? == false

    positions[target_x][target_y]
  end

  def find_direction(direction)
    direction_result = find_tokens(direction)
    opposite_direction_result = find_tokens(@directions[direction][:opposite])
    direction_result + opposite_direction_result + 1 >= 4
  end
end
