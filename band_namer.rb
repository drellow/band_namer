require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'rails'
require 'json'
require 'active_support/all'
load 'permutators.rb'

class BandNamer
  ALGORITHMS = [
    :lit_spooner, :the_lit_spooners, :the_adjective_nouns, :shuffle_wiki,
    :wiki_spooner, :wiki_rhymer, :moss, :gang_gang_dance, :shuffle_wiki_small,
    :wordmoss, :wikombine
  ]
  BOOKS = %w(music_theory.txt king_lear.txt the_sun_also_rises.txt sagan.txt random.txt moog.txt)

  def initialize(algorithm = nil)
    @algorithm = ALGORITHMS.sample || algorithm
    @name = perform_operations.letters_only.take(3).titleize
  end

  def perform_operations
    send(@algorithm)
  end

  def to_s
    @name
  end

  def algorithm
    @algorithm
  end

  def literature_me
    whole_book = File.read(BOOKS.sample).split(/(,|"|\n)/).select{|ph| ph != "," && ph != "\"" && ph != "\n"}
    whole_book.sample.split.join(" ")
  end

  def adjective
    JSON.parse(Nokogiri::HTML(open("https://www.randomlists.com/data/adjectives.json"))).to_a.flatten[rand(1130)]
  end

  def wikipedia_title
    Nokogiri::HTML(open("https://en.wikipedia.org/wiki/Special:Random")).css('title')[0].text.gsub(" - Wikipedia", "")
  end

  def new_dictionary_word
    JSON.parse(Nokogiri::HTML(open("https://www.vocabulary.com/dictionary/randomword.json")).css('p').text)["result"]["word"]
  end

  # def self.sanitize_me
  #   why did this exist?
  #   self.dup.gsub(/[^A-Za-z]/, ' ').split.take((2..6).to_a.sample).join(' ')
  # end

  private

  def gang_gang_dance
    (new_dictionary_word + " " + literature_me.take(1, true)).repeat_first_word
  end

  def wikombine
    shuffle_wiki.take(2, true).combine_words
  end

  def wordmoss
    new_dictionary_word + "moss"
  end

  def moss
    new_dictionary_word + " moss " + literature_me.take(1, true)
  end

  def wiki_rhymer
    "The" + " " + (wikipedia_title.take(1, true)).add_rhyme
  end

  def shuffle_wiki
    (wikipedia_title + " " + wikipedia_title).shuffle
  end

  def shuffle_wiki_small
    shuffle_wiki.take(2, true)
  end

  def lit_spooner
    literature_me.spoonerize
  end

  def wiki_spooner
    wikipedia_title.spoonerize
  end

  def the_lit_spooners
    "The" + " " + (lit_spooner.pluralize)
  end

  def the_adjective_nouns
    "The" + " " + adjective + " " + new_dictionary_word.pluralize
  end
end
