# frozen_string_literal: true

# class that represents the board in the connect_four game
class Board
  COLUMNS = 7
  ROWS = 6
  SIGN_EMPTY = '◯'

  attr_reader :positions

  def initialize
    @positions = initialize_positions
  end

  def initialize_positions
    rows = []
    COLUMNS.times do
      column = Array.new(ROWS, nil)
      rows << column
    end
    rows
  end

  def draw_board
    draw_column_numbers
    draw_column_arrows
    draw_rows
    puts "\e[90m▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨▨\e[0m"
  end

  def column_full?(column)
    @positions[column].last.nil? ? false : true
  end

  def drop_token(token, column)
    return if column_full?(column)

    token.position = { x: column, y: free_position(column) }
    @positions[column][free_position(column)] = token
  end

  def free_position(column)
    return if column_full?(column)

    @positions[column].index(nil)
  end

  def full?
    return false if @positions.flatten.include?(nil)

    true
  end

  private

  def draw_rows
    ROWS.times do |number|
      draw_row((number - ROWS + 1).abs)
    end
  end

  def draw_row(number)
    print "\e[90m  "
    positions.each { |column| draw_field(column[number]) }
    puts '|'
  end

  def draw_column_numbers
    print '  '
    COLUMNS.times do |col|
      output = column_full?(col) ? '    ' : "  #{col + 1} "

      print output
    end
    puts ''
  end

  def draw_column_arrows
    print '  '
    COLUMNS.times do |col|
      output = column_full?(col) ? '    ' : '  ▾ '

      print output
    end
    puts ''
  end

  def draw_field(field)
    output = field.nil? ? "| #{SIGN_EMPTY} " : "| #{field.sign} "

    print output
  end
end
