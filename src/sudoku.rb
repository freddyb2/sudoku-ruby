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
    raise "NOT COMPLETE" unless (CHARS_AUTHORIZED - chars).empty? && chars.count == CHARS_AUTHORIZED.count
  end

  def check_solution!
    CELLS_INDEXES.each { |index| check_chars! chars_in_line(index) }
    CELLS_INDEXES.each { |index| check_chars! chars_in_column(index) }
    SQUARES_INDEXES.each { |x| SQUARES_INDEXES.each { |y| check_chars! chars_in_square(x * GRID_POWER, y * GRID_POWER) } }
  end

  def possibilities(line_index, column_index)
    cell = cell(line_index, column_index)
    return nil if cell != CHAR_TO_COMPLETE
    CHARS_AUTHORIZED - chars_in_line(line_index) - chars_in_column(column_index) - chars_in_square(line_index, column_index)
  end

  def possibilities_in_square(cell_line_index, cell_column_index)
    square_line_index = cell_line_index / GRID_POWER
    square_column_index = cell_column_index / GRID_POWER
    line_min = square_line_index * GRID_POWER
    line_max = line_min + (GRID_POWER - 1)
    column_min = square_column_index * GRID_POWER
    column_max = column_min + (GRID_POWER - 1)
    (line_min..line_max).map { |line_index| (column_min..column_max).map { |column_index| (cell_column_index == line_index && cell_column_index == column_index) ? nil : possibilities(line_index, column_index) } }.compact.flatten
  end


  def solve_lines
    CELLS_INDEXES.each do |line_index|
      CELLS_INDEXES.each do |column_index|
        possibilities = possibilities(line_index, column_index)
        next unless possibilities
        possibilities_line = possibilities - CELLS_INDEXES.select { |y| y != column_index }.map { |y| possibilities(line_index, y) }.flatten
        possibilities_column = possibilities - CELLS_INDEXES.select { |x| x != line_index }.map { |x| possibilities(x, column_index) }.flatten
        possibilities_square = possibilities - possibilities_in_square(line_index, column_index)
        cell_solutions = [possibilities, possibilities_line, possibilities_column, possibilities_square]
                           .select { |p| p.count == 1 }
                           .flatten
                           .uniq

        write_cell(line_index, column_index, cell_solutions.first) if cell_solutions.count == 1
      end
    end
  end

  def write_cell(line_index, column_index, value)
    line = solution[line_index].split('')
    line[column_index] = value
    solution[line_index] = line.join
  end

  def chars_in_line(line_index)
    CELLS_INDEXES.map { |column_index| cell(line_index, column_index) }
  end

  def chars_in_column(column_index)
    CELLS_INDEXES.map { |line_index| cell(line_index, column_index) }
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
  GRID_POWER = 3
  CELLS_INDEXES = (0..(GRID_POWER ** 2 - 1)).to_a.freeze
  SQUARES_INDEXES = (0..(GRID_POWER - 1))
  CHARS_AUTHORIZED = (1..(GRID_POWER ** 2)).map(&:to_s).freeze

  def complete_line line
    chars = line.split ''
    return line unless chars.select { |char| char == CHAR_TO_COMPLETE }.count == 1
    chars.join.gsub(CHAR_TO_COMPLETE, (CHARS_AUTHORIZED - chars.select { |char| char != CHAR_TO_COMPLETE }).first)
  end

  attr_accessor :solution

  def initialize(grid)
    @solution = grid.dup
  end
end