require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.shuffle[0..9]
  end

  def score
    grid = params[:letters].gsub(" ","").chars
    attempt = params[:answer].upcase
    @score = 0
    session[:total_score] ||= 0
    if attempt_exist?(attempt) && check_attempt?(attempt, grid)
      @result = "Congratulations! #{attempt} is a valid English word"
      @score = attempt.size
    elsif attempt_exist?(attempt) == false
      @result = "Sorry but #{attempt} does not seem to be a valid English Word"
    elsif check_attempt?(attempt, grid) == false
      @result = "Sorry but #{attempt} can't be built out of #{params[:letters]}"
    end
    session[:total_score] += @score
    @total_score = session[:total_score]
  end

  def check_attempt?(attempt, grid)
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end

  def attempt_exist?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    JSON.parse(URI.open(url).read)["found"]
  end

end
