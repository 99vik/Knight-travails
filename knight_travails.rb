class Game
attr_accessor :board, :start_position
KNIGHT_MOVES = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]

  def initialize
    initialize_board
    draw_board
    initial_knight_placement
    loop do
      self.start_position = PositionNode.new((self.board.select { |key, value| value == "N" }.flatten[0]))
      move_knight
    end 
  end

  def move_knight
    puts "\nSelect position to move knight:"
    target = select_move_position(gets.strip)
    path = find_path(target).reverse
    change_board_position(path)
end

def change_board_position(path)
  path_display = [self.start_position.position]
  path.each do |i|
    path_display << i
    self.board[board.find { |key,value| value == "N" }[0]] = nil
    self.board[i] = "N"
    draw_board
    puts
    puts path_display.map { |i| "[#{i.join(", ")}]"}.join(" => ")
    sleep(1.5)
  end
end

def find_path(target)
  return [] if target == self.start_position.position
  queue = []
  possible_moves(self.start_position.position).each { |i| queue.push(PositionNode.new(i, self.start_position))}
  until queue.any? { |i| i.position == target }
    queued_position = queue.shift
    possible_moves(queued_position.position).each { |i| queue.push(PositionNode.new(i, queued_position))}
  end
  PositionNode.clear_history
  dig_path(queue.find { |i| i.position == target })
end

def dig_path(node, path = [])
  return path if node.parent == nil
  dig_path(node.parent, path.push(node.position))
end
 
def possible_moves(position)
    moves = []
    KNIGHT_MOVES.each { |i| moves << [i[0] + position[0], i[1] + position[1]] }
    moves = moves.select { |i| i.all?{ |j| j.between?(1, 8)} }
    moves = moves.reject { |i| PositionNode.history.include?(i) }
    moves
end

def select_move_position(input)
    input = input.split('')
    input.delete(' ')
    input = input.map{ |i| i.to_i }
    return wrong_input if !input_valid?(input)
    input
end

# position input
def wrong_input
    puts "Wrong input, try again."
    return select_move_position(gets.strip)
end

def initial_knight_placement
    puts "Please select position where you would like to put knight:"
    place_knight(input_position(gets.strip))
    draw_board
end

def place_knight(array)
    self.board[array] = "N"
end

def input_position(input)
    input = input.split('')
    input.delete(' ')
    input = input.map{ |i| i.to_i }
    return wrong_input if !input_valid?(input)
    input
end

def input_valid?(input)
    if input.length != 2 || !input.all? { |i| (1..8).to_a.include?(i)}
      puts "Incorrect input, please input 2 numbers from 1 to 8"
      return false
    else
        return true
    end
  end
  
  # board display
  def initialize_board
    self.board = Hash.new
    (1..8).to_a.each do |i|
      (1..8).to_a.each do |j|
        self.board[[i, j]] = nil
      end
    end
  end

  def draw_board
    puts
    (1..8).to_a.reverse.each do |i|
      row = self.board.select { |j| j[0] == i }
      draw_row(row)
    end
    puts "    1  2  3  4  5  6  7  8"
  end
  
  def draw_row(row)
    print "#{row.first[0][0]}  "
    row.each { |i| print_cell(i)}
    puts
end

  def print_cell(cell)
    if (cell[0][0].even? && !cell[0][1].even?) || (!cell[0][0].even? && cell[0][1].even?)
      if cell[1] != nil
        print " #{cell[1]} ".bg_white.black
      else
        print "   ".bg_white.black
      end
    else
      if cell[1] != nil
        print " #{cell[1]} "
      else
        print "   "
      end
    end
  end
end

class PositionNode
  attr_accessor :position, :parent, :history

  @@history = []

  def initialize(position, parent = nil)
    self.position = position
    self.parent = parent
    @@history.push(position)
  end

  def self.history
    @@history
  end

  def self.clear_history
    @@history = []
  end
end

class String
    def colorize(color_code)
        "\e[#{color_code}m#{self}\e[0m"
    end

    def black
      colorize(30)
    end

    def bg_white
      colorize(47)
    end
  end

  Game.new 