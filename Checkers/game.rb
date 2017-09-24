require_relative 'player'
require_relative 'computer_player'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'

class Game

  attr_accessor :current_player

  def initialize
    @board = Board.new
    @player1 = Player.new('White',:white, @board)
    @player2 = ComputerPlayer.new('Black',:black, @board)
    @current_player = @player1
  end

  def change_turns
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

  def game_over?
    @board.find_pieces(:white).empty? || @board.find_pieces(:black).empty?
  end


  #redo this so that player get moves are in the player class exculsively
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
  Game.new.play
end
