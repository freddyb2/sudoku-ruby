class Sudoku
  def self.solve grid
    new(grid).solve
  end

  def solve
    loop do
      solution_before = solution.dup
      solve_lines
      break if solution == solution_before
    end
    check_solution!
    solution
  end

  private

  def check_chars! chars
    chars_except_ignored = (chars - [CHAR_TO_IGNORE, CHAR_TO_COMPLETE])
    raise "ERROR" if chars_except_ignored.count != chars_except_ignored.uniq.count
  end

  def check_solution!
    SIDE_INDEXES.each { |index| check_chars! chars_in_line(index) }
    SIDE_INDEXES.each { |index| check_chars! chars_in_column(index) }
    (0..(GRID_POWER-1)).each do |v_index|
      (0..(GRID_POWER-1)).each do |h_index|
        check_chars! chars_in_square(v_index * GRID_POWER, h_index * GRID_POWER)
      end
    end
  end


  def solve_lines
    SIDE_INDEXES.each do |line_index|
      SIDE_INDEXES.each do |column_index|
        cell = cell(line_index, column_index)
        next unless cell == CHAR_TO_COMPLETE
        possibilities = CHARS_AUTHORIZED - chars_in_line(line_index) - chars_in_column(column_index) - chars_in_square(line_index, column_index)
        write_cell(line_index, column_index, possibilities.first) if possibilities.count == 1
      end
    end
  end

  def write_cell(line_index, column_index, value)
    line = solution[line_index].split('')
    line[column_index] = value
    solution[line_index] = line.join
  end

  def chars_in_line(line_index)
    SIDE_INDEXES.map { |column_index| cell(line_index, column_index) }
  end

  def chars_in_column(column_index)
    SIDE_INDEXES.map { |line_index| cell(line_index, column_index) }
  end

  def cell(line_index, column_index)
    solution[line_index].split('')[column_index]
  end

  def chars_in_square(cell_line_index, cell_column_index)
    square_line_index = cell_line_index / GRID_POWER
    square_column_index = cell_column_index / GRID_POWER
    line_min = square_line_index * GRID_POWER
    line_max = line_min + (GRID_POWER - 1)
    column_min = square_column_index * GRID_POWER
    column_max = column_min + (GRID_POWER - 1)
    (line_min..line_max).map { |line_index| (column_min..column_max).map { |column_index| cell(line_index, column_index) } }.flatten
  end

  CHAR_TO_COMPLETE = "x".freeze
  CHAR_TO_IGNORE = ".".freeze
  GRID_POWER = 3
  SIDE_INDEXES = (0..(GRID_POWER ** 2 - 1)).to_a.freeze
  CHARS_AUTHORIZED = (1..(GRID_POWER ** 2)).map(&:to_s).freeze

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