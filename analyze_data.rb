#!/usr/bin/env ruby

# Extended Mind
# Data Analyzer

require 'colorize'

def c(text)
  text.to_s.colorize(:color => :red)
end

data = File.read("data.csv").split("\n")
data.map! { |line| line.gsub '\,', ":::COMMA:::" }
data.map! { |line| line.split(",").map { |cell| cell.gsub ":::COMMA:::", "," } }

number_of_reached_entries = 0
number_of_failed_entries  = 0
total_clicks = 0
largest  = { :num => 0, :page => nil }
shortest = { :num => nil, :page => nil } 
data.each do |wiki_page_attempt|
  next if wiki_page_attempt.length < 4
  start   = wiki_page_attempt[0]
  clicks  = wiki_page_attempt[1].to_i + 1
  success = wiki_page_attempt[2] == "yes" ? true : false
  trail   = wiki_page_attempt[3].split(" -> ")

  total_clicks += clicks

  if success
    number_of_reached_entries += 1
  else
    number_of_failed_entries += 1
  end

  if clicks > largest[:num]
    largest[:page] = start
    largest[:num]  = clicks
  elsif shortest[:num].nil? or clicks < shortest[:num] 
    shortest[:page] = start
    shortest[:num]  = clicks
  end
end

percentage = (number_of_reached_entries.to_f / data.length * 100).round(2)

puts "#{c(number_of_reached_entries)} out of #{c(data.length)} pages reached Philosophy without recursing."
puts "#{c(number_of_failed_entries)} out of #{c(data.length)} pages recursed before reaching Philosophy."
puts "#{c(percentage.to_s + "%")} of pages reached Philosophy."
puts "#{c(largest[:page])} survived the longest with #{c(largest[:num])} clicks before reaching Philosophy."
puts "#{c(shortest[:page])} got to Philosophy the quickest with #{c(shortest[:num])} clicks."
