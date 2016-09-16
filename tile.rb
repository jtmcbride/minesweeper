class Tile

  attr_accessor :neighbors, :revealed, :flagged, :pos

  def initialize(row, col)
    @bomb = false
    @neighbors = 0
    @revealed = false
    @flagged = false
    @pos = [row, col]
  end

  def bomb?
    @bomb
  end

  def set_bomb
    @bomb = true
  end

  def incr_neighbors
    @neighbors += 1
  end

  # def inspect
  #   return "*"unless @revealed || @flagged
  #   bomb? ? "b" : @neighbors.to_s
  # end

  def to_s(t=false)
    if t
      return bomb? ? "b" : @neighbors.to_s
    end
    return "*" unless @revealed || @flagged
    bomb? ? "b" : @neighbors.to_s
   end


  def reveal
    @revealed = true
    @bomb ? false : true
  end

  def interior?
    @neighbors == 0 ? true : false
  end

  def flag
    @flagged = !@flagged
  end

end
