require 'rhymes'

class String
  VOWELS = %w(a e i o u)

  def spoonerize
    string = self

    if string.split.length <= 1
      return string
    elsif string.split.length > 2
      string = string.take(2)
    end

    first, second = string.split

    first_word_index = first.split("").find_index do |letter, i|
      letter.vowel?
    end

    second_word_index = second.split("").find_index do |letter, i|
      letter.vowel?
    end
    return string unless first_word_index && second_word_index
    first_word =  second[0..(second_word_index-1)] + first[first_word_index..-1]
    second_word = first[0..(first_word_index-1)] + second[second_word_index..-1]
    first_word + " " + second_word
  end

  def vowel?
    VOWELS.include?(self)
  end

  def combine_words
    string = self

    if string.split.length <= 1
      return string
    elsif string.split.length > 2
      string = string.take(2)
    end

    first, second = string.split

    first_word_index = first.split("").rindex do |letter, i|
      !letter.vowel?
    end || -1
    second_word_index = second.split("").find_index do |letter, i|
      letter.vowel?
    end || 0

    first_word = first[0..first_word_index]
    second_word = second[second_word_index..-1]

    first_word + second_word
  end

  def take(num_items, random = false)
    array = self.split
    if random
      new_array = []
      num_items.times do
        new_array << array.shuffle.pop
      end
      new_array.join(" ")
    else
      array[0..(num_items - 1)].join(" ")
    end
  end

  def letters_only
    self.gsub(/[^a-z ]/i, '')
  end

  def undisambiguate
    self.dup.sub("(disambiguation)", "").strip
  end

  def repeat_first_word
    array = self.split
    array.unshift(array.first)
    array.join(" ")
  end

  def shuffle
    self.split.shuffle.join(" ")
  end

  def add_rhyme
    self + " " + self.rhyme
  end

  def rhyme
    begin
      Rhymes.rhyme(self).sample
    rescue
      self
    end
  end
end
