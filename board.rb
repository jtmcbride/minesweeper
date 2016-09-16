require_relative 'tile'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(num_bombs = 10)
    @grid = new_grid
    @num_bombs = num_bombs
    seed_bombs
    count_neighbors
  end

  def new_grid
    arr = []
    9.times do |i|
      current = Array.new
      9.times do |j|
        current << Tile.new(i,j)
      end
      arr << current
    end
    arr
  end

  def render(t=false)
    @grid.each do |row|
      p row.map { |t| t.revealed }
    end
    nil
    # @grid.each do |row|
    #   row.map { |tile| tile.inspect }
    #   p row
    # end
    # nil
  end


  def seed_bombs
    bombs = 0
    until bombs == @num_bombs
      i = rand(0...9)
      j = rand(0...9)
      unless @grid[i][j].bomb?
        @grid[i][j].set_bomb
        bombs += 1
      end
    end
  end

  def won?
    num_revealed = grid.flatten.count {|tile| tile.revealed}
    if num_revealed == 81 - @num_bombs
      return true
    end
    false
  end

  def lost?

  end

  def reveal(pos, act)
    tile = @grid[pos[0]][pos[1]]

    case act
    when 'f'
     tile.flag
    when 'r'
      tile.reveal
      reveal_neighbors(tile) if tile.interior?
    else
      p "Not a valid move"
    end

  end

  def count_neighbors
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        row_idx == 0 ? previous_row = row_idx : previous_row = row_idx-1
        row_idx == 8 ? next_row = row_idx : next_row = row_idx+1
        col_idx == 0 ? previous_col = col_idx : previous_col = col_idx-1
        col_idx == 8 ? next_col = col_idx : next_col = col_idx+1

        if tile.bomb?
          unless row_idx == previous_row
            @grid[previous_row][previous_col..next_col].each do |t|
              t.incr_neighbors unless t.bomb?
            end
          end
          unless next_row == row_idx
            @grid[next_row][previous_col..next_col].each {|t| t.incr_neighbors unless t.bomb? }
          end
          @grid[row_idx][previous_col..next_col].each { |t| t.incr_neighbors unless t.bomb? }
        end
      end
    end
  end

  def [](x, y)
    @grid[x][y]
  end

  def reveal_neighbors(tile)

    #debugger
    neighbors = get_neighbors(tile)
    neighbors.each do |neighbor|
      if neighbor.interior? && !neighbor.revealed
         reveal_neighbors(neighbor)
       end
      neighbor.reveal
    end
  end

  def get_neighbors(tile)
    row_idx, col_idx = tile.pos[0], tile.pos[1]
    row_idx == 0 ? previous_row = row_idx : previous_row = row_idx-1
    row_idx == 8 ? next_row = row_idx : next_row = row_idx+1
    col_idx == 0 ? previous_col = col_idx : previous_col = col_idx-1
    col_idx == 8 ? next_col = col_idx : next_col = col_idx+1
    neighbors = []
    unless row_idx == previous_row
      @grid[previous_row][previous_col..next_col].each do |t|
        neighbors << t
      end
    end
    unless next_row == row_idx
      @grid[next_row][previous_col..next_col].each do |t|
        neighbors << t
      end
    end
    @grid[row_idx][previous_col..next_col].each_with_index do |t, i|
      next if t == tile
      neighbors << t
    end
    neighbors
  end

end
