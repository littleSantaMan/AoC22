# frozen_string_literal: true

input = File.read('./input.txt')

trees = input.split("\n").map do |row|
  row.scan(/./).map(&:to_i)
end

visible_trees = trees.map do |row|
  row.map { 0 }
end

def one_dir_visib(trees, visible_trees)
  trees.each_with_index do |row, i|
    tallest = -1
    row.each_with_index do |el,  j|
      next unless el > tallest

      tallest = el
      visible_trees[i][j] = 1
    end
  end

  return trees, visible_trees
end

def rotate(matrix)
  matrix.transpose.map(&:reverse)
end

def print_tree(trees)
  trees.each do |row|
    print row
    print "\n"
  end
end

4.times do
  trees, visible_trees = one_dir_visib(trees, visible_trees)
  trees, visible_trees = rotate(trees), rotate(visible_trees)
end

nr_visible_trees = visible_trees.map(&:sum).inject(:+)

# PART 1
puts nr_visible_trees

# PART 2 CODE

def score(tree, neighbours)
  neighbours = neighbours.dup.reverse
  steps = 0
  until neighbours.empty?
    neighbour = neighbours.pop
    steps += 1
    return steps if tree <= neighbour
  end
  steps
end

def one_dir_score(trees, tree_scores)
  trees.each_with_index do |row, i|
    row.each_with_index do |el,  j|
      tree_scores[i][j] << score(el, row[j+1..])
    end
  end

  return trees, tree_scores
end

tree_scores = trees.map do |row|
  row.map { [] }
end

4.times do
  trees, tree_scores = one_dir_score(trees, tree_scores)
  trees, tree_scores = rotate(trees), rotate(tree_scores)
end

tree_scores = tree_scores.map do |row|
  row.map do |scores|
    total_score = 1
    scores.each do |score|
      total_score *= score
    end
    total_score
  end
end

max_score = tree_scores.map do |row|
  row.max
end.max

# PART 2
puts max_score