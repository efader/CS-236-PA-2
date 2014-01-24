class Loaders
	#contains all methods to load data
	def load_data(path, sample)
		# puts raw data into an array
		raw_data = []
		if !sample
			file = File.open(path + '/u.data')
		elsif sample == :u1
			file = File.open(path + '/u1.base')
		end
		file.each_line do |line|
			raw_data << line.split.map(&:to_i)
		end
		return raw_data
	end

	def load_test(path, sample)
		# puts raw data into an array
		raw_data = []
		if !sample
			return raw_data
		elsif sample == :u1
			file = File.open(path + '/u1.test')
		end
		file.each_line do |line|
			raw_data << line.split.map(&:to_i)
		end
		return raw_data
	end

	def load_users(raw_data)
		# entry[0] is user, entry[1] is movie, entry[2] is rating 
		users = {}
		raw_data.each do |entry|
			if users[entry[0]]
				users[entry[0]][entry[1]] = entry[2]
			else
				users[entry[0]] = {entry[1] => entry[2]}
			end
			#update average rating
			if users[entry[0]][:pop]
				users[entry[0]][:pop] += entry[2]
			else 
				users[entry[0]][:pop] = entry[2]
			end	
		end
		return users
	end

	def load_movies(raw_data)
		# entry[0] is user, entry[1] is movie, entry[2] is rating 
		movies = {}
		raw_data.each do |entry|
			if movies[entry[1]]
				movies[entry[1]][entry[0]] = entry[2]
			else
				movies[entry[1]] = {entry[0] => entry[2]}
			end
			#update average rating
			if movies[entry[1]][:pop]
				movies[entry[1]][:pop] += entry[2]
			else 
				movies[entry[1]][:pop] = entry[2]
			end	
		end
		return movies
	end
end