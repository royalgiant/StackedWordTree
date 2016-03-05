class WordTreeProcessorController < ApplicationController
	def new
	end

	def create
		if params[:file].blank?
			flash[:danger] = "You need to select a file first."
		else 
			file = params[:file].read
			# Split up the string based on the \n break and assign the array to dataRows, sort by length, and remove duplicates
			word_array = file.split(/\r?\n/).group_by(&:length).sort.reverse
			
			a = Time.now 
			stacked_word_tree = recursion(word_array[0], word_array, 0, [], [])
			puts (Time.now - a).inspect
			# iterate(word_array)
			# raise 'ph'
			raise stacked_word_tree.inspect
		end
		render :new
	end

	def reduce_dup(word_array)
		word_array.each do |group|
			group[1].each do |word|

			end
		end
	end

	def iterate(word_array)
		word_lengths = []
		word_tree = []
		# raise word_array.inspect
		word_array.each do |word_group|
			word_lengths << word_group[0]
		end
		a = (word_lengths[0]..word_lengths.max).to_a
		b = word_lengths
		raise (a - b).inspect
	end

	def recursion(group_array, word_array, group_index, word_tree, cache)
		# If length == 2, we have reached the start (i.e. 3 letter word)
		
		if group_array[0] == 2
			return word_tree
		else
			# word_tree is not empty, make comparisons between each word and the last word of the
			# previous group in the word_tree to check that the former is a subset of the latter.
			if !word_tree.empty?
				wt = word_tree.last.chars
				word_found_flag = false # If a word was found to fit in the current word_tree
				group_array[1].each do |word|
					if ( word.chars - wt ).blank?
						# puts 'make it in here if'
						word_tree.push(word)
						word_found_flag = true
						break
					end	
				end
				puts word_tree.inspect
				puts ""
				if word_found_flag
					recursion(word_array[group_index+1], word_array, group_index+1, word_tree, cache)
				else
					cache[group_index+1] = true
					# There were no matches with respect to the last group, restart the word_tree
					recursion(word_array[group_index+1], word_array, group_index+1, [], cache)
				end
			else # The word_tree is empty, push a word onto it and recurse on the next group
				if cache[group_index] != true # We've not started on this group before, so start it.
					group_array[1].each do |word|
						word_tree.push(word)
						recursion(word_array[group_index+1], word_array, group_index+1, word_tree, cache)
					end 
				end
			end
		end
	end
end
