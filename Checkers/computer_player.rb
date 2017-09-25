class ComputerPlayer
  attr_reader :color, :name
  attr_accessor :board, :cursor

  def initialize(name,color,board)
    @name = name
    @color = color
    @board = board
    @cursor = (@color == :white ? [2,2] : [5, 3])
  end

  #attack if possible
  #otherwise move randomly
  #return a FROM position and a TO position [[from],[to]]
  def get_move
    #select pieces from find_pieces(@color) that have NON-empty attack_move arrays
    #select a random piece from that list and execute attack
    #
    attacking_pieces = @board.find_pieces(@color).select{|piece| !piece.attack_moves.empty?}
    #no attacks available
    if attacking_pieces.empty?

      threatened_squares = @board.threatened_squares(:white)
      all_moving_pieces = @board.find_pieces(@color).select{|piece| !piece.moves.empty?}

      #piece options is an array of pieces that have unthreatened moves
      piece_options = @board.find_unthreatened_pieces(@color)

      #there are pieces that exist with unthreated move options
      if !piece_options.empty?
        select_piece = piece_options.sample
        select_move = select_piece.moves.sample
        #don't pick a move that is threatened
        while threatened_squares.include?(select_move)
          select_move = select_piece.moves.sample
        end
      #there are no pieces with unthreatened move options
      else
        select_piece = all_moving_pieces.sample
        select_move = select_piece.moves.sample
      end
      return [select_piece.pos,select_move]
      #attack
    else
      select_piece = attacking_pieces.sample
      return [select_piece.pos,select_piece.attack_moves.sample]
    end

  end

  #return just a TO position [to]
  def continued_attack(piece)
    piece.attack_moves.sample
  end

end
