#Evan Fader
require_relative "loaders"

class MovieData
	def initialize(path, sample=nil)
		loader = Loaders.new
		@sample = sample
		@path = path
		@raw_data = loader.load_data(path, sample)
		@movies = loader.load_movies(@raw_data)
		@users = loader.load_users(@raw_data)
	end

	def rating(user, movie)
		if @users[user] && @users[user][movie]
			return @users[user][movie]
		else
			return 0
		end

	end

	def predict(user,movie)
		if @movies[movie] && @movies[movie][:avg]
			return @movies[movie][:avg]
		end
	end

	def predict2(user,movie)
		if @movies[movie][:avg]
			return @users[user][:avg]
		end
	end

	def movies(user)
		array = []
		if @users[user]
			@users[user].each_pair do |movie, rating|
				if user != :avg
					array << movie
				end
			end
		end
		return array
	end

	def viewers(movie)
		array = []
		if @movies[movie]
			@movies[movie].each_pair do |user, rating|
				if user != :avg
					array << user
				end
			end
		end
		return array
	end


	def process(x)
		return 1
	end

	def run_test(k=0)
		if !@sample
			return
		end
		loader = Loaders.new
		test_data = loader.load_test(@path, @sample)
		if k !=0
			test_data = test_data.first(k)
		end
		x=1
		test_data.each do |entry|
			entry[3] = predict(entry[0],entry[1])
		end
		return test_data
	end
end