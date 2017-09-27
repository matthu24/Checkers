class Soldier < Piece
  def move_dirs
    return [[1,1],[1,-1]] if @color == :white
    return [[-1,1],[-1,-1]] if @color == :black
  end

  def render
    '●'.colorize(color)
  end

  def promotion?
    return pos[0] == 7 if @color == :white
    return pos[0] == 0 if @color == :black
  end

end
