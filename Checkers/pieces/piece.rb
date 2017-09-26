class Piece
  attr_reader :board
  attr_accessor :color, :pos

  def initialize(color,board,pos)
    @color = color
    @board = board
    @pos = pos
  end

  #returns array of empty squares that a piece is threatening
  #a piece is threatening a square if the
  def squares_threatening
    threatening_set = []

    move_dirs.each do |direction|
      x,y = @pos[0] + direction[0],@pos[1] + direction[1]
      x2,y2 = @pos[0] + 2*direction[0],@pos[1] + 2*direction[1]
      next unless [x2,y2].all?{|i| i.between?(0,7)}
      #add square to threatening_set unless the destination square is occupied
      #threatening_set << [x,y]
      threatening_set << [x,y] if board[[x2,y2]].nil?
    end
    threatening_set
  end


  #including attack
  def moves
    moveset = []

    move_dirs.each do |direction|
      x,y = @pos[0] + direction[0],@pos[1] + direction[1]
      next unless [x,y].all?{|i| i.between?(0,7)}
      #advance
      if board[[x,y]].nil?
        moveset << [x,y]
        #attack
      elsif board[[x,y]].color != color
          x,y = @pos[0] + direction[0]*2,@pos[1] + direction[1]*2
          next unless [x,y].all?{|i| i.between?(0,7)}
          if board[[x,y]].nil?
            moveset << [x,y]
          end
      end
    end
    moveset
  end

  def attack_moves
    attack_moveset = []
    move_dirs.each do |direction|
      #assign x,y to the adjacent diagonal position
      x,y = @pos[0] + direction[0], @pos[1] + direction[1]
      next unless [x,y].all?{|i| i.between?(0,7)}
      #check if x,y is not nil && if the piece is an opposite color
      if !board[[x,y]].nil? && board[[x,y]].color != color
        x,y = @pos[0] + direction[0]*2,@pos[1] + direction[1]*2
        next unless [x,y].all?{|i| i.between?(0,7)}
        if board[[x,y]].nil?
          attack_moveset << [x,y]
        end
      end

    end
      attack_moveset
  end
end
