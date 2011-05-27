#!/usr/bin/env ruby

# Extended Mind
# Wikipedia checker, the concept is that for any Wikipedia article you can
# eventually get to the article on Philosophy if you click the first link
# on the article.
# http://xkcd.com/903 (see alt text)

require 'open-uri'
require 'nokogiri'

class ExtendedMind

  attr_accessor :breadcrumbs, :reached_end

  def initialize(start_page)
    @start_page  = start_page
    @breadcrumbs = []

    start
    crawl

    print_results
  end

  def wikify(page)
    "http://wikipedia.org" + page
  end

  def unwikify(page)
    page.gsub("/wiki/", "")
  end

  def remove_bracket_links(text)
    temp = text
    first_bracket = temp.index "("
    last_bracket = temp.length - 1

    return temp if first_bracket.nil?

    done = false
    opening_brackets = 0
    (first_bracket..last_bracket).each do |index|
      if temp[index] == "("
        opening_brackets += 1
      elsif temp[index] == ")"
        opening_brackets -= 1
        if opening_brackets == 0
          last_bracket = index
          break
        end
      end
    end
    return temp if temp[last_bracket + 1] == '"' # First brackets might be within a valid link.
    temp[first_bracket..last_bracket] = ""
    return temp
  end

  def print_results
    puts "\n[-] Unable to check, recurses.\n" if @reached_end.nil?
    puts "[#{@breadcrumbs.length}] " + @breadcrumbs.map { |crumb| unwikify(crumb) }.join(" -> ")
  end

  def remove(elm)
    elm.remove
  end

  def find_first_wikipedia_href(links)
    links.each do |link|
      return link.attr("href") if link.attr("href").index("http://").nil?
    end
  end

  def get_pages_first_link(url)
    puts url
    page = Nokogiri::HTML(open(url))
    content = page.css("#bodyContent")

    # Remove invalid links.
    content.css(".dablink", ".navbox", ".toccolours", ".image", ".infobox", ".new", ".toc", ".metadata").each(&:remove)
    content.css("p").first.inner_html = remove_bracket_links content.css("p").first.inner_html

    valid_links = content.css("p > a", "p > b > a", "ul > li > a")
    return find_first_wikipedia_href(valid_links)
  end

  def has_reached_end?
    return false if @breadcrumbs.length <= 2
    if @breadcrumbs.last == "/wiki/Philosophy"
      @reached_end = true
      return true
    end
    return @breadcrumbs[0..-2].include? @breadcrumbs.last
  end

  def add_crumb(url)
    @breadcrumbs << get_pages_first_link(wikify(url))
  end

  def start
    begin
      add_crumb("/wiki/#{@start_page}")
    rescue
      abort "Invalid start!"
    end
  end

  def crawl
    until has_reached_end?
      add_crumb(@breadcrumbs.last)
    end
  end

end

unless ARGV[0].nil?
  go = ExtendedMind.new(ARGV[0])
end
