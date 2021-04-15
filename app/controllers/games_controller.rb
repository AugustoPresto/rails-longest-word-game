require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = ['A', 'E', 'I', 'O', 'U']
  
  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letter].split

    @word = params[:word]
    @user_attempt_serialized = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    @user_attempt = JSON.parse(@user_attempt_serialized)

    @result = if @user_attempt["found"] && !@letters.include?(@word)
      { score: 0, message: "Sorry but #{@word.upcase} can't be built out of #{@letters.join(', ')}" }
    elsif !@user_attempt["found"]
      { score: 0, message: "Not an english word" }
    else
      { score: @user_attempt["length"], message: "Well Done!" }
    end
  end
end
