require "yaml"

class Hangman
	attr_reader :username
	attr_accessor :score, :secret_word, :display, :wrong_chars , :turns_left

	def initialize(username, score = 0)
		@username = username
		@score    = score 
		set_game_variables
	end

	def set_game_variables
		@secret_word = find_secret_word
		@display     = Array.new(secret_word.size, "_")
		@wrong_chars = []
		@turns_left  = 8
	end

	def word_bank
		File.open("dictionary.txt", "r").readlines
	end

	def find_secret_word
		random_index = rand(word_bank.size)
		word = word_bank[random_index].chomp.downcase
		word.size.between?(5, 12) ? word : find_secret_word
	end

	def display_flow(guess)
		matches = false

		secret_word.each_char.with_index do |char, index|
			if char == guess
				display[index] = guess
				matches = true
			end
		end
		wrong_chars << guess unless matches
	end

	def incorrect_guess(array)
		@turns_left -= 1 unless array.nil?
	end

	def game_winner?
		display.all? { |slot| slot != "_" }
	end

	def game_loser?
		turns_left == 0
	end

	def display_game
		puts "\n#{display.join(" ")} <= Guess the word!\n"
		puts "\n#{turns_left} <= Remaining guesses left\n"
		puts "\nWrong guesses #{wrong_chars.join(", ")}\n"
	end

	def user_guess
		puts "\nPlease enter a letter to guess!"
		guess = gets.chomp.downcase
	end

	def increase_score
		@score += (secret_word.size * 10)
	end

	def decrease_score
		@score -= 25
	end 

	def post_game
		if game_winner?
			increase_score
			puts "\nCongrats #{username}, you've won!"
			puts "Your score is now #{score}"
		else
			decrease_score
			puts "\nI'm sorry #{username}, the game is over, the word was #{secret_word}"
			puts "Your score is now #{score}"
		end
	end

	def play_again?
		puts "\nWould you like to play again? (y/n)"
		ask = gets.chomp
		if ask == "y"
			set_game_variables
			gameplay
		else
			save_game
			puts "Saving username and score...."
			exit
		end
	end

	def save_game
		Dir.mkdir("games") unless Dir.exist?("games")
		filename = "games/#{username}.yaml"
		data = {:username => @username, :score => @score}
		File.open(filename, "w") { |f| f.puts YAML.dump(data) }
	end

	def gameplay
		until game_winner? || game_loser?
			display_game
			incorrect_guess(display_flow(user_guess))
		end
		post_game
		play_again?
	end
end










