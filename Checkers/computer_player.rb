class ComputerPlayer
  attr_reader :color, :name
  attr_accessor :board, :cursor

  def initialize(name,color,board)
    @name = name
    @color = color
    @board = board
    @cursor = (@color == :white ? [2,2] : [5, 3])
  end

  #get move strategy: attack if possible

  #return a FROM position and a TO position [[from],[to]]
  def get_move
    
    attacking_pieces = @board.find_pieces(@color).select{|piece| !piece.attack_moves.empty?}
    #no attacks available
    #if no attacks available, iterate through every single piece and it's moves (double loop)
    #find the move for the minimum number of threatened pieces
    #make a holder for the minimum piece and its move
    if attacking_pieces.empty?
      all_moving_pieces = @board.find_pieces(@color)

      #stores the best possible moves
      piece_move_hash = Hash.new(0)
      threatened_difference = 10
      threatening_difference = 0

      number_threatened = @board.threatened_pieces_number(@color)
      enemy_color = (@color == :white ? :black : :white)
      number_threatening = @board.threatened_pieces_number(enemy_color)

      #pieces that can move into unthreatened spaces
       mobile_pieces = @board.find_mobile_pieces(@color)

       if mobile_pieces.empty?
         select_piece = all_moving_pieces.sample
         select_move = select_piece.moves.sample
         return [select_piece.pos,select_move]
       end

       mobile_pieces.each do |piece|
         piece.moves.each do |move|
           from = piece.pos
           dup_board = @board.dup
           dup_board.move!(@color,from,move)
           number_threatened_after = dup_board.threatened_pieces_number(@color)
           number_threatening_after = dup_board.threatened_pieces_number(enemy_color)
           #want this to be smallest
           new_threatened_difference = number_threatened_after - number_threatened
           #want this to be largest
           new_threatening_difference = number_threatening_after - number_threatening
           #update piece_move_hash
           if new_threatened_difference < threatened_difference
             threatened_difference = new_threatened_difference
             threatening_difference = new_threatening_difference
             piece_move_hash = Hash.new(0)
             piece_move_hash[piece] = move
           elsif new_threatened_difference == threatened_difference && new_threatening_difference > threatening_difference
             threatening_difference = new_threatening_difference
             piece_move_hash = Hash.new(0)
             piece_move_hash[piece] = move
           elsif new_threatened_difference == threatened_difference && new_threatening_difference == threatening_difference
             piece_move_hash[piece] = move
           end
         end
       end
       select_piece,select_move = piece_move_hash.to_a.sample

       return [select_piece.pos,select_move]
    #attack
    else
      select_piece = attacking_pieces.sample
      select_move = select_piece.attack_moves.sample

      return [select_piece.pos,select_move]
    end
  end

  #return just a TO position [to]
  def continued_attack(piece)
    piece.attack_moves.sample
  end

end
