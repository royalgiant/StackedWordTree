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
			stacked_word_tree = iterate(word_array[0], word_array, 0, [])
			raise stacked_word_tree.inspect
		end
		render :new
	end

	def iterate(group_array, word_array, group_index, word_tree)
		# If length == 2, we have reached the start (i.e. 3 letter word)
		
		if group_array[0] == 2
			return word_tree
		elsif group_array.blank? # If the group array is blank, go to the next group; word_tree restarts
			return iterate(word_array[group_index+1], word_array, group_index+1, [])
		else
			# word_tree is not empty, make comparisons between each word and the last word of the
			# previous group in the word_tree to check that the former is a subset of the latter.
			if !word_tree.empty?
				wt = word_tree.last.split(//)
				puts 'wt'
				puts wt.inspect
				group_array[1].each do |word|
					puts 'word'
					puts word.split(//).inspect
					puts "equal?"
					puts ( word.split(//) - wt ).empty?.inspect
					if ( word.split(//) - wt ).blank?
						# puts 'make it in here if'
						word_tree.push(word)
						puts 'word_tree'
						puts word_tree.inspect
						return iterate(word_array[group_index+1], word_array, group_index+1, word_tree)
					end	
				end
				# There were no matches with respect to the last word, restart the word_tree
				return iterate(word_array[group_index+1], word_array, group_index+1, [])
			else # The word_tree is empty, push a word onto it and recurse on the next group
				group_array[1].each do |word|
					puts 'make it in here else'
					word_tree.push(word)
					puts 'word_tree'
					puts word_tree.inspect
					return iterate(word_array[group_index+1], word_array, group_index+1, word_tree)
				end 
			end
		end
	end
end
