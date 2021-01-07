# frozen_string_literal: true

require 'open-uri'
require 'JSON'

require 'pry-byebug'

class GamesController < ApplicationController
  def new
    @letters = []
    @letters << %w[A E I O U].sample
    9.times { @letters << ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @check_dic = in_dictionnary?(@word)
    @check_letters = word_in_letters?(@word, @letters)
  end

  private

  def in_dictionnary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = JSON.parse(URI.open(url).read)
    result['found']
  end

  def word_in_letters?(word, letters)
    word_array = word.upcase.split('')
    word_array.each do |letter|
      id = letters.find_index(letter)
      if id
        letters.delete_at(id)
      else
        return false
      end
    end
    true
  end
end
