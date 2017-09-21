require_relative 'player'
require_relative 'board'
require_relative 'pieces'
require 'colorize'
require 'io/console'

class Game

  attr_accessor :current_player

  def initialize
    @board = Board.new
    @player1 = Player.new('White',:white, @board)
    @player2 = Player.new('Black',:black, @board)
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
      print "Your move, #{current_player.name}\n"
      from = @current_player.select
      to = @current_player.select
      @board.move!(@current_player.color,from,to)
      while @board.attack?(from,to) && @board.attack_possible?(to)
        print "Would you like to continue your attack?(y/n)"
        response =  $stdin.gets.chomp
        if response == "y"
          print "Select your next attack move"
          from = to
          to = @current_player.select
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
