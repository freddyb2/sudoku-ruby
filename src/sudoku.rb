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
  end

  def reverse_grid grid
    NUMBERS.map.with_index { |_, index| grid.map { |line| line.split('')[index] } }.map { |chars| chars.join }
  end

  CHAR_TO_COMPLETE = "x".freeze
  CHAR_TO_IGNORE = ".".freeze
  NUMBERS = (1..9).to_a.freeze
  CHARS_AUTHORIZED = NUMBERS.map(&:to_s).freeze

  def complete_line line
    chars = line.split ''
    return line if chars.include?(CHAR_TO_IGNORE)
    return line unless chars.include?(CHAR_TO_COMPLETE)
    chars.join.gsub(CHAR_TO_COMPLETE, (CHARS_AUTHORIZED - chars.select { |char| char != CHAR_TO_COMPLETE }).first)
  end

  attr_accessor :solution

  def initialize(grid)
    @solution = grid.dup
  end
end