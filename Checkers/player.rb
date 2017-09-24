class InputError < RuntimeError
end

class Player
  attr_reader :color, :name
  attr_accessor :cursor

  def initialize(name, color, board)
    @name = name
    @color = color
    @cursor = (@color == :white ? [2,2] : [5, 3])
    @board = board
  end

  #returns to and from positions
  def get_move
    print "Your move, #{@name}\n"
    from = select
    to = select
    [from,to]
  end

  #either returns new attack position [x,y] or returns nil
  def continued_attack(piece)
    print "Would you like to continue your attack?(y/n)"
    response =  $stdin.gets.chomp
    if response == "y"
      print "Select your next attack move"

      return select
    else
      return nil
    end
  end

  #this whole method controls the cursor moving ONE space
  def move_cursor(input)
    #case statement assigns a direction to dx,dy
    #dx, dy = case input
    #when 'w' then [-1, 0]
    #when 's' then [1, 0]
    #when 'a' then [0, -1]
    #when 'd' then [0, 1]
    #when 'q' then exit
    #end
    if input == 'w'
      dx,dy = [-1,0]
    elsif input == 's'
      dx,dy = [1,0]
    elsif input == 'a'
      dx,dy = [0,-1]
    elsif input == 'd'
      dx,dy = [0,1]
    elsif input == 'q'
      exit
    end


    x, y = [cursor[0] + dx, cursor[1] + dy]
    #returns cursor position, doesn't return a new cursor UNLESS x, and y are between 0 and 7, valid board spaces
    self.cursor = ([x, y].all? { |i| i.between?(0, 7) } ? [x, y] : self.cursor)
  end

  def select
    #until loop allows players to toggle pieces indefinitely-- until the ' ' space bar is hit
    #then cursor is saved as the position it is currently in

    until (input = STDIN.getch) == ' '

      #raise error unless the right characters are pressed
      unless ['w', 'a', 's', 'd', 'q', ' '].include?(input)
        raise 'Use W, A, S, D, Space; Q to quit'
      end
      #receive input, which calls method to move the cursor position
      #input is STDIN.getch from above, which is a keystroke from user
      move_cursor(input)
      #constant rendering of the shifting cursor
      @board.render(cursor)
    end
    #return position of cursor
    cursor
  end
end
