require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'rails'
require 'json'
require 'active_support/all'

class BandNamer

  PERMUTATORS = [:delete_some_words, :repeat_some_words, :add_random_words, :delete_some_words,
                 :shuffle_them_words, :take_two, :add_adjective, :king_lear_me, :sun_rise_me]
  KING_LEAR = File.read('king_lear.txt').split(/(,|\n)/).select{|ph| ph != "," && ph != "\n"}
  SUN_ALSO_RISES = File.read('the_sun_also_rises.txt').split(/(,|")/).select{|ph| ph != "," && ph != "\""}

  attr_accessor :name

  def initialize word=nil
    @word = word
    if rand(2) == 1
      @name = new_name
    else
      @name = new_dictionary_word
    end
    @permutations = []
    do_stuff
  end

  def do_stuff
    PERMUTATORS.shuffle.each do |method|
      if rand(2) == 1
        @name = send(method, @name)
        @permutations << method
      end
    end
    @name = @name.pluralize if rand(3) == 1
    @name = add_special_word(@name, @word) if @word
    @name = @name.sub("(disambiguation)", "")
    @name = sanitize_me(@name)
    @name = caps(@name)
  end

  def add_adjective name
    adjective + " " + name
  end

  def king_lear_me name
    new_name = name.split
    name.split.each_with_index do |word, i|
      KING_LEAR.sample.split.each do |sun_word|
        new_name.insert(i, sun_word)
      end
    end
    new_name.join(' ')
  end

  def sun_rise_me name
    new_name = name.split
    name.split.each_with_index do |word, i|
      SUN_ALSO_RISES.sample.split.each do |sun_word|
        new_name.insert(i, sun_word)
      end
    end
    new_name.join(' ')
  end

  def adjective
    JSON.parse(Nokogiri::HTML(open("http://www.randomlists.com/data/adjectives.json"))).to_a.flatten[rand(1130)]
  end

  def new_name
    Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Special:Random")).css('span')[0].text
  end

  def new_dictionary_word
    JSON.parse(Nokogiri::HTML(open("http://www.vocabulary.com/dictionary/randomword.json")).css('p').text)["result"]["word"]
  end

  def caps name
    array = name.split
    array.map! {|w| w.capitalize}
    array.join " "
  end

  def repeat_some_words name
    array = name.split
    random_index = rand(array.length + 1)
    array[random_index + 1] = array[random_index]
    array.join(" ")
  end

  def add_random_words(name)
    array = name.split
    rand(4).times do
      array << JSON.parse(Nokogiri::HTML(open("http://www.vocabulary.com/dictionary/randomword.json")).css('p').text)["result"]["word"]
    end
    array.join(" ")
  end

  def shuffle_them_words name
    name.split.shuffle.join(" ")
  end

  def add_special_word(name, word)
    array = name.split
    array.shuffle!
    array << word
    array.shuffle!.join(" ")
  end

  def delete_some_words name
    array = name.split
    (array.length / 2).times do 
      array.delete_at(rand(array.length + 1))
    end
    array.join(" ")
  end

  def sanitize_me name
    name.gsub(/[^0-9A-Za-z]/, ' ').split.take(5).join(' ')
  end

  def take_two name
    array = name.split
    new_array = []
    2.times do
      new_array << array.shuffle.pop
    end
    new_array.join(" ")
  end

end