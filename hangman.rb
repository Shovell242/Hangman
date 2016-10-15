require_relative "game.rb"
require "yaml"

def save_game
	Dir.mkdir("games") unless Dir.exists?("games")
	fname = "games/#{self.username}.yaml"
	File.open(fname, "w") { |f| f.puts YAML.dump(self) }
end

def load_game(username)
	content = File.open("games/#{username}.yaml", "r") { |f| f.read }
	YAML.load(content)
end

puts "\nWelcome to Hangman!\n"
print "Please enter your username > "
input = gets.chomp
if File.exists?("#{input}.yaml")
	game = load_game(input)
else
	game = Hangman.new
end
game.gameplay
