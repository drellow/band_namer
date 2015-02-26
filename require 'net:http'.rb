require 'rubygems'
require 'nokogiri'
require 'open-uri'

class BandNamer

  def page
    Nokogiri::HTML(open("http://en.wikipedia.org/wiki/Special:Random"))   
  end

  def article_title
    page.css('span')[0].text
  end

  def permute_in_some_ways

  end

  def pluralize(name)
    "the " + name + "s"
  end

end