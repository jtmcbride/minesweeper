class Tile

  attr_accessor :neighbors

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
    unless @revealed || @flagged
      "*"
    end
    if bomb?
      "b"
    else
      @neighbors.to_s
    end
  end

  def reveal
    @revealed = true
  end


end
