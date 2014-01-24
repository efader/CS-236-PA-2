#Evan Fader
require_relative "loaders"
require_relative "movie_test"

class MovieData
	def initialize(path, sample=nil)
		loader = Loaders.new
		@sample = sample
		@path = path
		@raw_data = loader.load_data(path, sample)
		@movies = loader.load_movies(@raw_data)
		@users = loader.load_users(@raw_data)
		@time = 0
	end

	def rating(user, movie)
		if @users[user] && @users[user][movie]
			return @users[user][movie]
		else
			return 0
		end
	end

	def predict(user,movie)
		# the prediction is based on the average review for the movie
		# and partially adjusted based on the average review of the user
		if @movies[movie] && @movies[movie][:pop]
			movieavg = @movies[movie][:pop].to_f / (@movies[movie].length-1).to_f
			useravg = @users[user][:pop].to_f / (@users[user].length-1).to_f
			return movieavg + (useravg - 3.55)*0.75
		end
	end

	def benchmark
		return @time
	end

	def movies(user)
		array = []
		if @users[user]
			@users[user].each_pair do |movie, rating|
				if user != :pop
					# ignore popularity field
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
				if user != :pop
					# ignore popularity field
					array << user
				end
			end
		end
		return array
	end

	def run_test(k=0)
		if !@sample
			return
		end
		loader = Loaders.new
		test_data = loader.load_test(@path, @sample)
		if k !=0
			# limit test to k trials unless k is zero or unspecified
			test_data = test_data.first(k)
		end
		# start time for benchmarking
		@time = Time.now
		test_data.each do |entry|
			#change unused timestamp field to prediction field
			entry[3] = predict(entry[0],entry[1])
		
		#end time for benchmarking
		@time = (Time.now - @time) / test_data.length
		return test_data
	end
end

instance = MovieData.new('ml-100k',:u1)
tester = MovieTest.new(instance.run_test)
puts "The mean error is:"
puts tester.mean
puts "The standard deviation is:"
puts tester.stdev
puts "The root mean square is:"
puts tester.rms
puts "The average time for running each prediction is:"
puts instance.benchmark