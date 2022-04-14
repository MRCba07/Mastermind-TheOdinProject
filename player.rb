class Player
  attr_reader :name

  def initialize(board, name)
    @name = name
    @board = board
  end # End of initialize

  def make_pattern
    # Makes a pattern to guess or makes a guess. Player roles are controled by the main loop
    valid_items = @board.permitted_colours
    selection = []
    puts "Select your pattern (do it number by number, not all together):"
    valid_items.each_with_index do |item, idx|
      print "(#{idx+1})  #{item}"
      puts
    end
    4.times do |num|
      selection << valid_items[gets.chomp.strip.to_i - 1]
    end
    selection
  end # End of make_pattern
end # End of class Player
