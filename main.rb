require "./game.rb"
require "yaml"

def get_user
	puts "\nWelcome to Hangman!\n"
	print "Enter your username > "
	name = gets.chomp
end

def start_game(name)
	file = "games/#{name}.yaml"
	if File.exist?(file)
		content = File.open(file, "r") { |f| f.read }
		data    = YAML.load(content)
		Hangman.new(data[:username], data[:score]).gameplay
	else
		Hangman.new(name).gameplay
	end
end

def high_scores
	Dir["games/*"].reduce([]) do |arr, x|
		data    = File.open(x, "r") { |f| f.read }
		arr << YAML.load(data)
		arr
	end
end

def display
	puts "\tLEADERBOARD\n"
	sort = high_scores.sort_by { |k, v| v }
	puts "\tUser\tScore"
	puts "\t----------------"
	sort.each { |x| puts "\t#{x[:username]}\t#{x[:score]}" }
end

display
start_game(get_user)