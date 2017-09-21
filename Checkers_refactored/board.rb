class Board
  attr_accessor :grid
  def initialize(fill = true)
    @grid = Array.new(8) {Array.new(8)}
    setup_board if fill
  end

  def [] (pos)
    row,col = pos
    @grid[row][col]
  end

  def []= (pos,piece)
    row,col = pos
    @grid[row][col] = piece
  end

  #returns list of all pieces in array
  def pieces
    @grid.flatten.compact
  end

  def find_pieces(color)
    pieces.select {|piece| piece.color == color}
  end

  #change board, and Piece.pos
  def move!(color,from,to)
    piece = self[from]
    raise "No piece there\n" if piece.nil?
    raise "That's not your piece.\n" unless piece.color == color
    raise "Can't move there.\n" unless piece.moves.include?(to)
    self[from],self[to], piece.pos = nil, piece, to
    #if attack, need to get rid of enemy piece
    if attack?(from,to)
      x,y = (from[0] + to[0])/2, (from[1]+to[1])/2
      self[[x,y]] = nil
    end


    if piece.is_a?(Soldier)
      self[to] = King.new(piece.color,self,to) if piece.promotion?
    end

  end

  def attack?(from,to)
    (from[0] - to[0]).abs > 1
  end

  def attack_possible?(from)
    piece = self[from]
    !piece.attack_moves.empty?
  end

  #continued attack strategy:
  #loop move until move is not an attack and a continued attack is not possible
  #if move is an attack and a continued attack is possible, ask player if want to continue attack
  #if yes, then color and from are then preselected for the next move
  #must select from attack moves (might need to make another one)
  #player is then asked to select an attack move
  # move is executed


  #black rows 0,1,2
  #white rows 5,6,7
  def setup_board
    even_cols = (0..7).to_a.select{|num| num % 2 == 0}
    odd_cols = (0..7).to_a.select{|num| num % 2 == 1}

    even_cols.each do |col|
      self[[0,col]] = Soldier.new(:white,self,[0,col])
      self[[2,col]] = Soldier.new(:white,self,[2,col])
      self[[6,col]] = Soldier.new(:black,self,[6,col])
    end

    odd_cols.each do |col|
      self[[1,col]] = Soldier.new(:white,self,[1,col])
      self[[5,col]] = Soldier.new(:black,self,[5,col])
      self[[7,col]] = Soldier.new(:black,self,[7,col])
    end

  end

  def render(cursor)
    system("clear")
    @grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        bgc = :light_gray if [i, j] == cursor
        bgc ||= ((i + j).even? ? :light_black : :red)
        print " #{square.nil? ? ' ' : square.render }  ".colorize(:background => bgc)
      end

      puts
    end
  end

end