class Board
  PATTERN_SIZE = 4
  COLOR_NUMBER = 6
  OFF_COLOR = "\033[0m"
  RED = "\033[0;91m" + "o" + OFF_COLOR
  BLUE = "\033[0;94m" + "o" + OFF_COLOR
  YELLOW = "\033[0;93m" + "o" + OFF_COLOR
  GREEN = "\033[0;92m" + "o" + OFF_COLOR
  WHITE = "\033[0;97m" + "o" + OFF_COLOR
  PINK = "\033[0;95m" + "o" + OFF_COLOR

  def initialize(board_size = 12, blanks = false, duplicates = false)
    @board_size = board_size
    @blanks = blanks
    @duplicates = duplicates
    @pattern = []
    @pattern_history = []
    @feedback_history = []
  end # End of initialize

  def define_pattern(pattern)
    # Define the pattern to guess
    if self.valid?(pattern)
      @pattern = pattern
      true
    else
      return false
    end
  end # End of define_pattern

  def blank
    # Deletes history to start a new round
    @pattern = []
    @pattern_history = []
    @feedback_history = []
    nil
  end # End of blank

  def endgame?
    # Has the game ended?
    return (@pattern_history.size == @board_size || self.winner?)
  end # End of endgame?

  def winner?
    # Has there been a winner?
    return (@pattern_history[-1] == @pattern ) # The last guess and the pattern match
  end # End of winner?

  def display_board # Does not display the shield
    # Prints the board to the console
    @pattern_history.each_with_index do |pattern, idx| # Display each guess in order
      print "GUESS #{idx + 1}    "
      pattern.each do |item|
        print " #{item}"
      end
      print " ||"
      @feedback_history[idx].each do |item|
        print " #{item}"
      end
      puts
    end
  end # End of display_board

  def display_pattern
    print "PATTERN    "
    @pattern.each do |item|
      print " #{item}"
    end
    puts
  end

  def play_turn(pattern)
    # plays a turn and automatically generates feedback
    if self.valid?(pattern)
      @pattern_history << pattern
      self.generate_feedback # Returns the new feedback array
                        # It is automatically added to history
    else
      return false
    end
  end # End of play_turn

  def permitted_colours
    # Returns an array containing the permitted colors, blanks
    # Duplicates will be checked by other functions
    colours = [RED, BLUE, YELLOW, GREEN, WHITE, PINK] # Basic colors
    colours << ' ' if @blanks
    colours
  end # End of permitted_colours

  def display_rules
    # Print rules to the console
    puts "These are the rules of the game."
  end # End of display_rules

  def pattern_history
    # Returns the pattern history
    @pattern_history
  end # End of pattern_history

  def feedback_history
    # Returns the feedback history
    @feedback_history
  end # End of feedback_history

  private
  def valid?(pattern)
    # Determine if the provided pattern is valid
    # Check if each item is a valid item
    valid = self.permitted_colours
    pattern.each do |item|
      return false unless valid.include?(item) # If the item is not valid
    end
    # Check for duplicates
    unless @duplicates
      return pattern.uniq == pattern # No duplicates were deleted
    end
    return true
  end

  def generate_feedback
    # Generates feedback for the last guess played
    feedback_code = []
    color_pegs = []
    @pattern.each_with_index do |item, idx|
      if item == @pattern_history[-1][idx]
      color_pegs << idx
      end
    end
    key_pegs = []
    @pattern_history[-1].each_with_index do |item, idx|
      next if color_pegs.include?(idx) # We already checked that item
      @pattern.each_with_index do |item2, idx2|
        next if color_pegs.include?(idx2) # Already checked
        next if key_pegs.include?(idx2) # Already checked
        if item == item2
          key_pegs << idx2
        end
      end
    end
    color_pegs.size.times do |num|
      feedback_code << GREEN
    end
    key_pegs.size.times do |num|
      feedback_code << WHITE
    end
    feedback_history << feedback_code
    feedback_code
  end
end # End of class Board