# frozen_string_literal: true

input = File.read('./input.txt')

commands = input.split("\n")[1..]

current_folder = ['/']

files = {}

commands.each do |command|
  if match = command.match(/\$ cd (?<folder>.*)/)
    next current_folder.pop if match[:folder] == '..'

    current_folder << match[:folder]
  end

  if match = command.match(/(?<size>\d.*) (?<file>.*)/)
    files[current_folder.dup << match[:file]] = match[:size]
  end
end

dirs = {}
files.each do |file, size|
  file = file.dup
  while file.size > 1
    file.pop
    file_ = file.dup
    dirs[file_] ||= 0
    dirs[file_] += size.to_i
  end
end

# PART 1
result_dirs = dirs.select do |_dir, size|
  size <= 100_000
end

puts result_dirs.values.sum

# PART 2

to_free_up = 30_000_000 - (70_000_000 - dirs[['/']])
candidates = dirs.values
candidates = candidates.select do |size|
  size >= to_free_up
end
puts candidates.min

# 1844187 p.1
# 4978279 p.2
