require 'json'
require "open-uri"

class GamesController < ApplicationController

  def new

    @game_letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @word = params[:attempt]
    @game_letters = params[:game_letters].split
    @response = if correct_letters?(@word, @game_letters)
                  if exists?(@word)
                    'banging word bro!'
                  else
                    "Sorry but <strong>#{@word}</strong> doesn't seem to be a valid English word..."
                  end
                else
                  "Sorry but <strong>#{@word}</strong> can't be built out of #{@game_letters.join(', ')} "
                end
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
end
