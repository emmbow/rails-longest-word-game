require "open-uri"
require "json"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:grid].split("")
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    @score = calc_score(@word) if @included && @english_word
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def calc_score(word)
    word.length * word.length
  end
end


# class GamesController < ApplicationController
  # def new
  #   @letters = []
  #   10.times do
  #     alphabet = ('A'...'Z').to_a
  #     @letters << alphabet.sample
  #   end
  #   @letters
  # end

#   def score
#     @word = params[:word]
#     @letters = params[:grid]
#     # Does the array contain the letters of the word?
#     if does_word_exist?(@word, @letters) == false
#       @result = "Sorry but #{@word.upcase} cannot be made out of #{@letters.split('').join(", ")}"
#     elsif word_valid?(@word) == false
#       @result = "Sorry but #{@word.upcase} is not a valid English word"
#     else
#       @result = "Congratulations, #{@word.upcase} is a valid English word!"
#       @score = "You scored #{calc_score(@word)} points."
#       @total = "You have #{total_score(@score)} points in total."
#     end
#   end

#   def does_word_exist?(word, letters)
#     word.chars.all? do |letter|
#       word.chars.count(letter) <= letters.downcase.chars.count(letter)
#     end
#   end

#   def word_valid?(word)
#     url = "https://wagon-dictionary.herokuapp.com/#{word}"
#     json = JSON.parse(open(url).read)
#     json['found']
#   end

#   def calc_score(word)
#     word.length * word.length
#   end

#   def total_score(score)
#   # requires active storage
#   end
# end
