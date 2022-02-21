require './player.rb'

class ConnectFour
  attr_accessor :board

  EMPTY_CIRCLE = "\e[37m\u25cb".freeze
  BLUE_CIRCLE = "\u001b[34m\u25cf".freeze
  RED_CIRCLE = "\u001b[31m\u25cf".freeze

  LAST_ROW = 5

  def initialize
    @board = Array.new(6) { Array.new(7, EMPTY_CIRCLE) }
    @player1 = Player.new('Player 1', BLUE_CIRCLE)
    @player2 = Player.new('Player 2', RED_CIRCLE)
  end

  def validate_input(input)
    return true if [0, 1, 2, 3, 4, 5, 6].include?(input) && !column_full?(input)

    false
  end

  def marks_in_column(column)
    count = 0
    for i in 0..5 do
      count += 1 if @board[i][column] != EMPTY_CIRCLE
    end
    count
  end

  def set_mark(column, player)
    marks = marks_in_column(column)
    return if marks > 5

    row = LAST_ROW - marks
    @board[row][column] = player.symbol
  end

  def play_game
    current_player = @player1
    until connected_four?
      play_round(current_player)
      if current_player == @player1 then current_player = @player2 else current_player = @player1 end
    end
    print_board
    puts "\u001b[32mCongrats! #{current_player.name} you won the Game!"
  end

  def play_round(player)
    column = ''
    print_board
    until validate_input(column)
      print_round_ui(player)
      column = gets.chomp.to_i
    end
    set_mark(column, player)
  end

  def column_full?(column)
    return true if @board[0][column] != EMPTY_CIRCLE

    false
  end

  def connected_four?
    return true if connected_row
    return true if connected_column
    return true if connected_diagonal

    false
  end

  def connected_row
    @board.each do |row|
      count = 0
      prior_element = nil
      row.each do |element|
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
      end
    end
    false
  end

  def connected_column
    prior_element = nil
    for column_index in 0..6 do
      for row_index in 0..5 do
        element = @board[row_index][column_index]
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
      end
    end
    false
  end

  def connected_diagonal
    traverse_diagonals
  end

  def traverse_diagonals
    return traverse_leftside_one || traverse_leftside_two || traverse_rightside_one || traverse_rightside_two
  end

  def traverse_leftside_one
    prior_element = nil
    for row_index in 0..2 do
      column_index = 0
      count = 0
      while column_index <= 6 && row_index <= 5
        element = @board[row_index][column_index]
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
        row_index += 1
        column_index += 1
      end
    end
    false
  end

  def traverse_leftside_two
    prior_element = nil
    for column_index in 1..3 do
      row_index = 0
      count = 0
      while column_index <= 6 && row_index <= 5
        element = @board[row_index][column_index]
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
        row_index += 1
        column_index += 1
      end
    end
    false
  end

  def traverse_rightside_one
    prior_element = nil
    for row_index in 0..2 do
      column_index = 6
      count = 0
      while column_index >= 0 && row_index <= 5
        element = @board[row_index][column_index]
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
        row_index += 1
        column_index += -1
      end
    end
    false
  end

  def traverse_rightside_two
    prior_element = nil
    for column_index in 3..5 do
      row_index = 0
      count = 0
      while row_index >= 0 && column_index >= 0
        element = @board[row_index][column_index]
        count = count_connected_marks(count, prior_element, element)
        return true if count == 3

        prior_element = element
        row_index += 1
        column_index += -1
      end
    end
    false
  end

  def count_connected_marks(count, prior_element, element)
    return 0 if prior_element.nil?

    count += 1 if prior_element == element && element != EMPTY_CIRCLE
    count = 0 if prior_element != element

    count
  end

  def print_board
    puts
    @board.each do |column|
      column.each do |element|
        print element
        print ' '
      end
      print "\n"
    end
    puts "\u001b[33m0 1 2 3 4 5 6"
    puts
  end

  def print_round_ui(current_player)
    puts "\e[37m#{current_player.name} select a column:"
  end
end

c = ConnectFour.new
c.play_game
