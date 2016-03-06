require 'array'
class WordTreeProcessorController < ApplicationController
	def new
	end

	def create
		if params[:file].blank?
			flash[:danger] = "You need to select a file first."
		else 
			file = params[:file].read
			# Split up the string based on the \n break
			word_array = file.split(/\r?\n/)
			# Make an array of arrays grouped by length
			words_by_length = make_length_buckets(word_array)

			# Loop through each group of words
			tree = words_by_length.reverse.eval_find do |words|
				# For each word 
			  	Array(words).eval_find do |word|
			    	get_chain(word, words_by_length)
			  	end
			end
			raise tree.inspect
		end
		render :new
	end
	
	def make_length_buckets(words)
		# Loop through each word with a []
		words.each.with_object([]) do |w, o|
		    o[w.length] ||= []  # if o[key] does not exist, make it
		    o[w.length] << w # throw the word into o[key]
		end
	end

	def get_chain(word, words_by_length) 
	  r_get_chain(word, words_by_length, 0, []) # start the recursive function 
	end

	def r_get_chain(word, words_by_length, index, chain)
	  chain[index] = word # each incremental word is one letter less. Assign word to hash
	  return chain[0..index] if word.length == 3 # return the chain hash if we made it to the end
	  # Get next set of words
	  next_words = get_next_words(word, words_by_length[word.length.pred]) 
	  # Recurse through the new words from next_words array and repeat until one makes it to word_length == 3  
	  next_words.eval_find do |next_word|
	    r_get_chain(next_word, words_by_length, index + 1, chain)
	  end
	end

	def get_next_words(root, words)
		# Select the WORDS which has every character in the superset
		Array(words).select do |word|
		    (word.chars - root.chars).empty?
		end
	end
end