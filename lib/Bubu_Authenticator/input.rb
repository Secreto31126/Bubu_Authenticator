# frozen_string_literal: false

# Parses the arguments and returns an array
module Input
  def self.args
    args = []
    ARGV.each do |input|
      if input.start_with?("-") || args.empty?
        args.push input.dup
      elsif !args.last.start_with?("-")
        args.last << " " << input.dup
      else
        args.push input.dup
      end
    end
    args
  end

  # Loop until user input is valid
  def self.get_user_input(length)
    loop do
      print "[1 - #{length}]: "
      # Why not 0? Because .to_int returns 0 if the input is a string,
      # so if the user writes a string the program needs to catch it
      i = $stdin.gets.chomp.to_i

      return (i - 1) if i.positive? && i <= length

      puts "Invalid input, choose between 1 and #{length}"
    end
  end
end
