# frozen_string_literal: true

DIRS = { # Directions, Right means +1 on x axis.
  'R' => [ 1, 0],
  'L' => [-1, 0],
  'U' => [ 0, 1],
  'D' => [ 0,-1]
}.freeze

# Adjusts the position of the adjacent knot +t_pos+.
# @param [Array(Integer, Integer)] h_pos The reference knot
# @param [Array(Integer, Integer)] t_pos The target knot, whose position
#   needs to be adjusted with respect to +h_pos+
def adjust(h_pos, t_pos)
  x_diff = h_pos[0] - t_pos[0]
  y_diff = h_pos[1] - t_pos[1]
  pos_diff = [x_diff, y_diff]
  longer_i = pos_diff.find_index do |x|
    x.abs == 2
  end

  # validation
  pos_diff.each { |x| raise(StandardError, 'The tail got lost') if x.abs > 2 }

  return unless longer_i

  shortr_i = longer_i == 1 ? 0 : 1
  scale = pos_diff[shortr_i].abs == 2 ? 2 : 1

  t_pos[longer_i] = t_pos[longer_i] +  pos_diff[longer_i] / 2
  t_pos[shortr_i] = t_pos[shortr_i] + (pos_diff[shortr_i] / scale)
end

# Based on +movements+ and +knots+ positions, it updates the +t_hist+ Hash
# with the unique positions that it has.
# @param [Array<Array(Integer, Integer)>] movements An array of movements
#   for the first knot in +knots+. Each element is an array, with displacements
#   in x and y positions.
# @param [Array<Array(Integer, Integer)>] knots An array of consecutive knots.
#   The first knot is the HEAD, the last knot is the TAIL.
# @param [Hash] t_hist A Hash that tracks the position of the last knot.
def track_tail(movements, knots, t_hist)
  movements.each do |x_diff, y_diff|
    knots.first[0] += x_diff
    knots.first[1] += y_diff
    (knots.size - 2).times.map do |i|
      adjust(knots[i], knots[i + 1])
    end
    adjust(knots[-2], knots[-1])
    t_hist[knots.last.dup] ||= 1
  end
end

# Based on +movements+ and +nr_knots+, it calculates how many
# unique positions the TAIL (last element in +knots+) has, provided
# that all knots start in the same position.
# @param [Array<Array(Integer, Integer)>] movements An array of movements
#   for the first knot in +knots+. Each element is an array, with displacements
#   in x and y positions.
# @param [Integer] nr_knots The number of knots in a row
# @return [Integer] The number of unique positions that the TAIL in the rope
#   assumes after the HEAD executes the +movements+
def nr_slots(movements, nr_knots)
  # first knot is the head, last knot is the tail
  knots = nr_knots.times.map do
    [0, 0]
  end
  t_hist = {}

  track_tail(movements, knots, t_hist)
  t_hist.size + 1
end

# PROCESS INPUT ---- START -----
input = File.read('./ls_input.txt')

movements = input.split("\n").flat_map do |row|
  direction, steps = row.split(' ')
  Array.new(steps.to_i, DIRS[direction])
end
# @example movements
# [
#  [ 0, 1], # one up
#  [ 0, 1], # one up
#  [-1, 0], # one to the left
#    ...    # ...
# ]
#
# PROCESS INPUT ---- FINISH -----

# PART 1
puts nr_slots(movements, 2)
# PART 2
puts nr_slots(movements, 10)

# P1: 6391
# P2: 2593















# BONUS:
# Prints the places where the tail has been. Same format as in the example
def print_tail_hist(hist)
  size = 40
  screen = size.times.map do |_row|
    Array.new(size, '.')
  end

  hist.each do |pos|
    screen[-pos.first[1] - size / 2][pos.first[0] - size / 2] = '#'
  end
  screen[size / 2][size / 2] = 'S'
  screen.each do |row|
    print "#{row.join('')}\n"
  end
end
# print_tail_hist(t_hist)

# ls p1: 6340 (too high) --> 6339 worked!
# ls p2: 2542 (too high) --> 2541 worked!
