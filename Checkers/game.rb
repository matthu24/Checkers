require_relative 'player'
require_relative 'computer_player'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'

class Game

  attr_accessor :current_player

  def initialize(board,player1,player2)
    @board = board
    @player1 = player1
    @player2 = player2
    @current_player = @player1
  end

  def change_turns
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

  def game_over?
    @board.find_pieces(:white).empty? || @board.find_pieces(:black).empty?
  end


  def play
    @board.render(current_player.cursor)
    until game_over?
      begin
      #use get_move method
      from,to  = @current_player.get_move
      @board.move!(@current_player.color,from,to)
      while @board.attack?(from,to) && @board.attack_possible?(to)
        #use continued_attack method
          from = to
          to = @current_player.continued_attack(@board[from])
          unless to == nil
            @board.move!(@current_player.color,from,to)
          else
            break
          end
      end
      change_turns
      @board.render(current_player.cursor)
    rescue RuntimeError => e
      print e
      retry
    end
    end
    print "Game Over\n"
  end
end

if __FILE__ == $PROGRAM_NAME

  print "Play with computer? (y/n)"
  board = Board.new
  if $stdin.gets.chomp == "y"

    player1 = Player.new('White',:white, board)
    player2 = ComputerPlayer.new('Black',:black, board)
  else
    player1 = Player.new('White',:white, board)
    player2 = Player.new('Black', :black, board)
  end

  Game.new(board,player1,player2).play
end
