#!/usr/bin/env ruby

# Extended Mind
# Finds longest trail to Philosophy.

require File.dirname(__FILE__) + "/run"
require 'net/http'
require 'uri'

def e(text)
  text.to_s.gsub(",", "\,")
end

def add_data(start, trail, quantity, finished)
  output = File.open("data.csv", "a")
  output.puts "#{e(start)},#{e(trail.length)},#{finished ? "yes":"false"},#{e(trail.join(" -> "))}"
end

def get_new_link
  temp = Net::HTTP.get_response URI.parse('http://en.wikipedia.org/wiki/Special:Random')
  return temp["location"].split("/").last
end

largest = { :quantity => 0, :page => nil }
loop {
  begin
    wiki_page = get_new_link
    g = ExtendedMind.new(get_new_link)
    add_data(wiki_page, g.breadcrumbs, g.breadcrumbs.length, g.reached_end)
    if g.breadcrumbs.length > largest[:quantity]
      largest[:quantity] = g.breadcrumbs.length
      largest[:page] = wiki_page

      puts "New largest! (#{largest[:quantity]} clicks from #{wiki_page} to Philosophy)."
    end
  rescue SystemExit, Interrupt
    raise
  rescue Exception => e
    puts "Invalid page occurred, skipped."
    puts e
  end
}
