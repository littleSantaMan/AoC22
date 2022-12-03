# frozen_string_literal: true

# rubocop: disable Style/SingleLineMethods

input = File.read('./input.txt')

bags = input.split("\n")

def split_bag(bag_pair)
  [bag_pair[0..(bag_pair.size / 2 - 1)], bag_pair[(bag_pair.size / 2)..]]
end

# @return [String] the shared type
def search_bag_pair(bag1, bag2)
  bag1 = bag1.split(//) # Split into arrays of characters
  bag2 = bag2.split(//) # Split into arrays of characters
  until bag2.include? popped = bag1.pop
    bag1.delete(popped)
    bag2.delete(popped)
  end
  popped
end

# UPPER_CASE = (65..90).freeze
LOWER_CASE = (97..122)

def get_priority(letter)
  codepoint = letter.ord
  codepoint - (LOWER_CASE.include?(codepoint) ? 96 : 38)
end

priorities = bags.map do |bag_pair|
  bag1, bag2 = split_bag(bag_pair)
  shared_type = search_bag_pair(bag1, bag2)
  get_priority(shared_type)
end

puts priorities.sum
