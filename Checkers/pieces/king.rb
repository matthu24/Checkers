class King < Piece
  def move_dirs
    [[1,1],[1,-1],[-1,1],[-1,-1]]
  end

  def render
    '◎'.colorize(color)
  end

end
