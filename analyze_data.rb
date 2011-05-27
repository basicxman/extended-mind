#!/usr/bin/env ruby

# Extended Mind
# Data Analyzer

require 'colorize'
require 'ap'

def c(text)
  text.to_s.colorize(:color => :red)
end

def unwikify(page)
  page.gsub("/wiki/", "")
end

data = File.read("data.csv").split("\n")
data.map! { |line| line.gsub '\,', ":::COMMA:::" }
data.map! { |line| line.split(",").map { |cell| cell.gsub ":::COMMA:::", "," } }

number_of_reached_entries = 0
number_of_failed_entries  = 0
total_clicks = 0
largest  = { :num => 0, :page => nil }
shortest = { :num => nil, :page => nil } 
pages_causing_recursion = []
data.each do |wiki_page_attempt|
  next if wiki_page_attempt.length < 4
  start   = wiki_page_attempt[0]
  clicks  = wiki_page_attempt[1].to_i + 1
  success = wiki_page_attempt[2] == "yes" ? true : false
  trail   = wiki_page_attempt[3].split(" -> ")

  if success
    total_clicks += clicks
    number_of_reached_entries += 1
    if clicks > largest[:num]
      largest[:page] = start
      largest[:num]  = clicks
    elsif shortest[:num].nil? or clicks < shortest[:num] 
      shortest[:page] = start
      shortest[:num]  = clicks
    end
  else
    number_of_failed_entries += 1
    recursed_page = unwikify(trail.last)
    pages_causing_recursion << recursed_page
  end

end

percentage = (number_of_reached_entries.to_f / data.length * 100).round(2)
num_recursing_pages = pages_causing_recursion.uniq.length
average_clicks = (total_clicks.to_f / number_of_reached_entries).round(2)

causes = {}
pages_causing_recursion.each do |page|
  unless causes[page].nil?
    causes[page] += 1
  else
    causes[page] = 1
  end
end

largest_cause = { :num => 0, :page => nil }
causes.each do |page, value|
  if value > largest_cause[:num]
    largest_cause[:num]  = value
    largest_cause[:page] = page
  end
end

puts "Out of #{c(data.length)} trails generated:"
puts "#{c(number_of_reached_entries)} out of #{c(data.length)} pages reached Philosophy without recursing."
puts "#{c(number_of_failed_entries)} out of #{c(data.length)} pages recursed before reaching Philosophy."
puts "#{c(percentage.to_s + "%")} of pages reached Philosophy."
puts "#{c(largest[:page])} survived the longest with #{c(largest[:num])} clicks before reaching Philosophy."
puts "#{c(shortest[:page])} got to Philosophy the quickest with #{c(shortest[:num])} clicks."
puts "#{c(average_clicks)} is the average number of clicks to reach Philosophy."
puts "#{c(num_recursing_pages)} pages when clicked on will doom the trail to recursion."
puts "#{c(largest_cause[:page].dup)} caused recursion #{c(largest_cause[:num])} times."
