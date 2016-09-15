class Tile

  attr_accessor :neighbors, :revealed, :flagged

  def initialize
    @bomb = false
    @neighbors = 0
    @revealed = false
    @flagged = false
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

  def inspect
    return "*"unless @revealed || @flagged
    bomb? ? "b" : @neighbors.to_s
  end

  def reveal
    @revealed = true
    @bomb ? false : true
  end

  def flag
    @flagged = !@flagged
  end

end
