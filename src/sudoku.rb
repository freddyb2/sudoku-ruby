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
  end

  CHAR_TO_COMPLETE = "x".freeze
  CHAR_TO_IGNORE = ".".freeze
  CHARS_AUTHORIZED = (1..9).to_a.map(&:to_s).freeze

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