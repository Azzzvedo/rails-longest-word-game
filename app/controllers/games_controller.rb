require 'json'
require "open-uri"

class GamesController < ApplicationController

  def new
    @game_letters = Array.new(10) { ('a'..'z').to_a.sample }
    @starting = Time.now
  end

  def score
    @word = params[:attempt]
    @time = (Time.now - Time.parse(params[:starting])).to_f
    @game_letters = params[:game_letters].split
    @response = message(@word, @game_letters, @time)
  end

  def message(word, letters, time)
    if correct_letters?(word, letters)
      if exists?(word)
        @score = score_value(time, word.length)
        "banging word bro! You scored #{@score}"
      else
        @score = 0
        "Sorry but <strong>#{word}</strong> doesn't seem to be a valid English word..."
      end
    else
      @score = 0
      "Sorry but <strong>#{word}</strong> can't be built out of #{letters.join(', ')} "
    end
  end

  def score_value(time, length)
    length**(time * -1)
  end

  def exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)['found']
  end

  def correct_letters?(word, compare_letters)
    word_array = word.downcase.chars
    word_array.all? { |l| word_array.count(l) <= compare_letters.count(l) }
  end


  # time consuming operation

end
