require_relative 'tile'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(num_bombs = 10)
    @grid = new_grid
    @num_bombs = num_bombs
    seed_bombs
    count_neighbors
    @a = Array.new(9) {Array.new(9) {0}}
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

  def render
    @grid.each do |row|
      row.map { |tile| tile.inspect }
      p row
    end
    nil
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
      reveal_neighbors(tile, pos) if tile.neighbors == 0
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

  def reveal_neighbors(tile, pos)
    # debugger
    row_idx, col_idx = pos[0], pos[1]
    row_idx == 0 ? previous_row = row_idx : previous_row = row_idx-1
    row_idx == 8 ? next_row = row_idx : next_row = row_idx+1
    col_idx == 0 ? previous_col = col_idx : previous_col = col_idx-1
    col_idx == 8 ? next_col = col_idx : next_col = col_idx+1
    unless row_idx == previous_row
      @grid[previous_row][previous_col..next_col].each_with_index do |tile, i|
        @a[tile.pos[0]][tile.pos[1]] += 1
        tile.reveal
        reveal_neighbors(tile, tile.pos) if tile.neighbors == 0 && !tile.revealed
      end
    end
    unless next_row == row_idx
      @grid[next_row][previous_col..next_col].each_with_index do |tile, i|
        @a[tile.pos[0]][tile.pos[1]] +=1
        tile.reveal
        reveal_neighbors(tile, tile.pos) if tile.neighbors == 0 && !tile.revealed
      end
    end
    @grid[row_idx][previous_col..next_col].each_with_index do |tile, i|
      @a[tile.pos[0]][tile.pos[1]] +=1
      next if i == 1
      tile.reveal
      reveal_neighbors(tile, tile.pos) if tile.neighbors == 0 && !tile.revealed
    end
  end
end
