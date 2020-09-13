class Grid

  def write_cell(line_index, column_index, value)
    line = grid[line_index].split('')
    line[column_index] = value
    grid[line_index] = line.join
  end

  def chars_in_line(line_index)
    CELLS_INDEXES.map { |column_index| cell(line_index, column_index) }
  end

  def chars_in_column(column_index)
    CELLS_INDEXES.map { |line_index| cell(line_index, column_index) }
  end

  def cell(line_index, column_index)
    grid[line_index].split('')[column_index]
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

  def possibilities_in_square(cell_line_index, cell_column_index)
    square_line_index = cell_line_index / GRID_POWER
    square_column_index = cell_column_index / GRID_POWER
    line_min = square_line_index * GRID_POWER
    line_max = line_min + (GRID_POWER - 1)
    column_min = square_column_index * GRID_POWER
    column_max = column_min + (GRID_POWER - 1)
    (line_min..line_max).map { |line_index| (column_min..column_max).map { |column_index| (cell_column_index == line_index && cell_column_index == column_index) ? nil : possibilities(line_index, column_index) } }.compact.flatten
  end

  def possibilities_in_column(line_index, column_index)
    CELLS_INDEXES.select { |x| x != line_index }.map { |x| possibilities(x, column_index) }.flatten
  end

  def possibilities_in_line(line_index, column_index)
    CELLS_INDEXES.select { |y| y != column_index }.map { |y| possibilities(line_index, y) }.flatten
  end

  def possibilities(line_index, column_index)
    cell = cell(line_index, column_index)
    return [] if cell != CHAR_TO_COMPLETE
    CHARS_AUTHORIZED - chars_in_line(line_index) - chars_in_column(column_index) - chars_in_square(line_index, column_index)
  end

  def solve_lines
    CELLS_INDEXES.each do |line_index|
      CELLS_INDEXES.each do |column_index|
        possibilities = possibilities(line_index, column_index)
        next unless possibilities
        possibilities_line = possibilities - possibilities_in_line(line_index, column_index)
        possibilities_column = possibilities - possibilities_in_column(line_index, column_index)
        possibilities_square = possibilities - possibilities_in_square(line_index, column_index)
        cell_solutions = [possibilities, possibilities_line, possibilities_column, possibilities_square]
                             .select { |p| p.count == 1 }
                             .flatten
                             .uniq

        write_cell(line_index, column_index, cell_solutions.first) if cell_solutions.count == 1
      end
    end
  end

  def grids_to_explore
    CELLS_INDEXES.map do |line_index|
      CELLS_INDEXES.map do |column_index|
        possibilities(line_index, column_index).map do |cell_solution|
          grid_to_explore = Grid.from_grid(self)
          grid_to_explore.write_cell(line_index, column_index, cell_solution)
          grid_to_explore
        end
      end
    end.flatten
  end

  def check_chars! chars
    raise "NOT COMPLETE" unless chars.sort == CHARS_AUTHORIZED
  end

  def solution_reached?
    CELLS_INDEXES.each { |index| check_chars! chars_in_line(index) }
    CELLS_INDEXES.each { |index| check_chars! chars_in_column(index) }
    SQUARES_INDEXES.each { |x| SQUARES_INDEXES.each { |y| check_chars! chars_in_square(x * GRID_POWER, y * GRID_POWER) } }
    true
  rescue
    false
  end

  CHAR_TO_COMPLETE = "x".freeze
  GRID_POWER = 3
  CELLS_INDEXES = (0..(GRID_POWER ** 2 - 1)).to_a.freeze
  SQUARES_INDEXES = (0..(GRID_POWER - 1))
  CHARS_AUTHORIZED = (1..(GRID_POWER ** 2)).map(&:to_s).freeze

  def ==(other)
    self.grid == other.grid
  end

  def imprime
    CELLS_INDEXES.each do |line_index|
      CELLS_INDEXES.each do |column_index|
        cell = cell(line_index, column_index)
        content = cell == CHAR_TO_COMPLETE ? possibilities(line_index, column_index) : [cell]
        print("[" + content.map(&:to_s).join + (1..(CELLS_INDEXES.count - content.count)).to_a.map { |_| " " }.join + "]")
        print "   " if ((column_index + 1) % GRID_POWER == 0)
      end
      puts
      puts if ((line_index + 1) % GRID_POWER == 0)
    end
  end

  attr_accessor :grid

  def self.from_rows(grid)
    new(grid.dup)
  end

  def self.from_grid(grid)
    new(grid.grid.dup)
  end

  def initialize(grid)
    @grid = grid
  end
end

class Sudoku
  def self.solve grid
    new.solve Grid.from_rows(grid)
  end

  def solve(grid)
    grid_solved = solve_with_method(grid)
    return grid_solved if grid_solved.solution_reached?
    explore(grid_solved)
  end

  private

  def solve_with_method(grid)
    grid_solved = Grid.from_grid(grid)
    grid_solved.solve_lines
    return grid_solved if grid_solved == grid
    solve_with_method grid_solved
  end

  def explore(grid)
    grid.grids_to_explore.each do |grid_to_explore|
      solution = self.solve grid_to_explore
      return solution if solution
    end
    nil
  end
end