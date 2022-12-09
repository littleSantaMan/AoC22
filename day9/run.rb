# frozen_string_literal: true

input = File.read('./input.txt')

DIRS = {
  'R' => [1, 0],
  'L' => [-1 ,0],
  'U' => [0, 1],
  'D' => [0, -1]
}

movements = input.split("\n").flat_map do |row|
  direction, steps = row.split(' ')
  Array.new(steps.to_i, DIRS[direction])
end

h_pos = [0, 0]
t_pos = [0, 0]

t_hist = {}

def adjust(h_pos, t_pos, t_hist)
  x_diff = h_pos[0] - t_pos[0]
  y_diff = h_pos[1] - t_pos[1]
  pos_diff = [x_diff, y_diff]
  longer_i = pos_diff.find_index do |x|
    x.abs == 2
  end

  return unless longer_i

  shortr_i = longer_i == 1 ? 0 : 1

  t_pos[longer_i]  = t_pos[longer_i] + pos_diff[longer_i] / 2
  t_pos[shortr_i]  = t_pos[shortr_i] + pos_diff[shortr_i]

  t_hist[t_pos.dup] ||= 1
end

movements.each do |x_diff, y_diff|
  h_pos[0] += x_diff
  h_pos[1] += y_diff
  adjust(h_pos, t_pos, t_hist)
end

puts t_hist.size + 1

# PART 2

def adjust(h_pos, t_pos, t_hist = nil)
  x_diff = h_pos[0] - t_pos[0]
  y_diff = h_pos[1] - t_pos[1]
  pos_diff = [x_diff, y_diff]
  longer_i = pos_diff.find_index do |x|
    x.abs == 2
  end

  return unless longer_i

  shortr_i = longer_i == 1 ? 0 : 1

  t_pos[longer_i]  = t_pos[longer_i] + pos_diff[longer_i] / 2
  t_pos[shortr_i]  = t_pos[shortr_i] + pos_diff[shortr_i]

  if t_hist
    t_hist[t_pos.dup] ||= 0
    t_hist[t_pos.dup] += 1
  end
  
end

h_pos = [0, 0]
pos_1 = [0, 0]
pos_2 = [0, 0]
pos_3 = [0, 0]
pos_4 = [0, 0]
pos_5 = [0, 0]
pos_6 = [0, 0]
pos_7 = [0, 0]
pos_8 = [0, 0]
t_pos = [0, 0]

t_hist = {}

movements.each do |x_diff, y_diff|
  h_pos[0] += x_diff
  h_pos[1] += y_diff
  adjust(h_pos, pos_1)
  adjust(pos_1, pos_2)
  adjust(pos_2, pos_3)
  adjust(pos_3, pos_4)
  adjust(pos_4, pos_5)
  adjust(pos_5, pos_6)
  adjust(pos_6, pos_7)
  adjust(pos_7, pos_8)
  adjust(pos_8, t_pos, t_hist)
end

puts t_hist.size + 1        # unique values
puts t_hist.values.sum + 1  # non-unique values

# i guessed 2252 (unique) and 2340 (not unique)

# Prints the places where the tail has been.
def print_(hist)
  size = 40
  screen = size.times.map do |_row|
    Array.new(size, '.')
  end

  hist.each do |pos|
    screen[-(pos.first[1]) - size / 2][(pos.first[0]) - size / 2] = '#'
  end
  screen[size / 2][size / 2] = 'S'
  screen.each do |row|
    print row.join('') + "\n"
  end
end
# print_(t_hist) It shows the correct picture, just like in the example