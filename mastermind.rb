require './board'
require './player'

# This is the main program

# Introduce the game
puts "MASTERMIND"

# Ask the user how many games to play (must be even)
number_of_games = nil
loop do
  print "How many games do you wish to play?"
  number_of_games = gets.chomp.to_i
  puts
  if (number_of_games.even? && number_of_games > 0)
    break
  else
    puts "Invalid number"
  end
end

# Will the user be the codemaker or the codebreaker first?
puts "Do you wish to be the codemaker (1) or the codebreaker (2)?"
role = gets.chomp.to_i

# Select difficulty
puts "Easy (1) or hard (2) difficulty?"
difficulty = gets.chomp.to_i

# Are duplicates and blanks allowed?
puts "Allow duplicates? (y/n)"
duplicates = (gets.chomp.downcase == 'y')? true : false
puts "Allow blanks? (y/n)"
blanks = (gets.chomp.downcase == 'y')? true : false

# How many turns? 8 to 12 turns
turns = nil;
loop do
  print "How many turns? (8 to 12)"
  turns = gets.chomp.to_i

  if (8..12).include?(turns)
    break
  else
    puts "Invalid number"
  end
end

# Create the board
board = Board.new(turns, blanks, duplicates)

# Set starting roles
# Revise this when you finish writing your computer classes
roles = [Player.new(board, "P1"), Player.new(board, "P2")] # [codemaker, codebreaker]
roles.reverse! if role == 2

# Set starting scores
scores = [0, 0]

# State the rules of the current game
board.display_rules

# Enter main loop
counter = 0
loop do
  # Define if the codebreaker is human or not
  # Let the codemaker make a code
  puts "Codemaker #{roles[0].name}, make a pattern."
  pattern = roles[0].make_pattern
  until board.define_pattern(pattern)
    puts "Invalid pattern. Try another one."
    pattern = roles[0].make_pattern
  end
  # Enter game loop
  loop do
    # Let the codebreaker make a guess
    puts "Codebreaker #{roles[1].name}, make a pattern"
    pattern = roles[1].make_pattern
    until board.play_turn(pattern)
      puts "Invalid pattern. Try another one."
      pattern = roles[1].make_pattern
    end

    # If the codebreaker is human, display the board.
    board.display_board if roles[1].class == Player
    # Has the game ended?
    break if board.endgame?
  # Finish game loop
  end
  # If the codebreaker is not human, display the final board
  board.display_board if roles[1].class != Player

  # Supply the original pattern
  board.display_pattern
  puts

  # Calculate and state score of codemaker
  scores[0] += board.pattern_history.size
  scores[0] += 1 unless board.winner? # The codebreaker did not guess correctly

  # Change roles and scores
  roles.reverse!
  scores.reverse!

  # Reset the board
  board.blank

  # Has the game ended?
  counter += 1
  puts "END OF ROUND #{counter}"
  print "\n\n\n"
  break if (counter == number_of_games)
# Finish main loop
end

# State the winner with both players' score
puts "#{roles[0].name}'s score is #{scores[0]}"
puts "#{roles[1].name}'s score is #{scores[1]}"
if scores[0] != scores[1]
  puts "The winner is #{(scores[0] > scores[1])? roles[0].name : roles[1].name}!"
else
  puts "It's a draw!"
end
