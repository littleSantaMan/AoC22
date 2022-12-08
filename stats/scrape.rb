# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::HTML.parse(open('https://adventofcode.com/2022/stats'))

storage = doc.css('pre').first.children.each_with_object({}) do |day, storage|
  next unless day.children.any?

  day_nr = day.children[0].text.strip.to_i
  gold   = day.children[1].text.strip.to_i
  silver = day.children[2].text.strip.to_i
  storage[day_nr] = {
    gold: gold,
    silver: silver
  }
end

File.open("storage/#{Time.now.utc}.json",'w') do |f|
  f.write(JSON.pretty_generate(storage))
end
