require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    @letters = 10.times.map { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_details_serialized = URI.open(url).read
    word_details = JSON.parse(word_details_serialized)
    word_array = @word.upcase.chars
    if word_details["found"] == false
    @result = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    elsif word_array.all? { |letter| params[:letters].include?(letter) } && word_array.all? do |letter|
            word_array.count(letter) <= params[:letters].count(letter)
          end
      @result = "Congratulations! #{@word.upcase} is a valid English word!"
    else
      @result = "Sorry but #{@word.upcase} can't be built out of #{params[:letters]}"
    end
    return @result
  end
end