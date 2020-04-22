class Sudoku
  def self.solve grid
    new(grid).solve
  end

  def solve
    solve_lines
  end

  private

  def solve_lines
    self.solution = solution.map(&method(:complete_line))
    self.solution = reverse_grid(reverse_grid(solution).map(&method(:complete_line)))
    self.solution = reverse_squares(reverse_squares(solution).map(&method(:complete_line)))
  end

  def reverse_squares(grid)
    (0..(SQUARES_SIDE - 1)).map do |square_line_index|
      (0..(SQUARES_SIDE - 1)).map do |square_column_index|
        line_min = square_line_index * SQUARES_SIDE
        line_max = line_min + (SQUARES_SIDE - 1)
        column_min = square_column_index * SQUARES_SIDE
        column_max = column_min + (SQUARES_SIDE - 1)

        line_select = grid.select.with_index { |_, index| (line_min..line_max).to_a.include? index }
        reverse_grid = reverse_grid(line_select)
        column_select = reverse_grid.select.with_index { |_, index| (column_min..column_max).to_a.include? index }
        reverse_grid(column_select).join
      end
    end.flatten
  end

  def reverse_grid grid
    NUMBERS.map.with_index { |_, index| grid.map { |line| line.split('')[index] } }.map { |chars| chars.join }
  end

  CHAR_TO_COMPLETE = "x".freeze
  CHAR_TO_IGNORE = ".".freeze
  NUMBERS = (1..9).to_a.freeze
  SQUARES_SIDE = Math.sqrt(NUMBERS.count).to_i
  CHARS_AUTHORIZED = NUMBERS.map(&:to_s).freeze

  def complete_line line
    chars = line.split ''
    return line if chars.include?(CHAR_TO_IGNORE)
    return line unless chars.select { |char| char == CHAR_TO_COMPLETE }.count == 1
    chars.join.gsub(CHAR_TO_COMPLETE, (CHARS_AUTHORIZED - chars.select { |char| char != CHAR_TO_COMPLETE }).first)
  end

  attr_accessor :solution

  def initialize(grid)
    @solution = grid.dup
  end
end