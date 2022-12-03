# frozen_string_literal: true

input = File.read('./input.txt')

bags = input.split("\n")

# @param [String] bag1
# @return [String] the shared type between the three bags
def search_bag_pair(bag1, bag2, bag3)
  bag1 = bag1.split(//) # Split into arrays of characters
  bag2 = bag2.split(//)
  bag3 = bag3.split(//)
  until (bag2.include? popped = bag1.pop) && (bag3.include? popped)
    bag1.delete(popped)
    bag2.delete(popped)
    bag3.delete(popped)
  end
  popped
end

# UPPER_CASE = (65..90).freeze
LOWER_CASE = (97..122)

def get_priority(letter)
  codepoint = letter.ord
  codepoint - (LOWER_CASE.include?(codepoint) ? 96 : 38)
end

priorities = []
bags.each_slice(3) do |bag1, bag2, bag3|
  shared_type = search_bag_pair(bag1, bag2, bag3)
  priorities << get_priority(shared_type)
end

puts priorities.sum
