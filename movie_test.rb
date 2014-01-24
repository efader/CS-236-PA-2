class MovieTest
	def initialize(data)
		@test_data = data
		@mean = calculate_mean
		@stdev = calculate_stdev
	end

	def to_a
		return @test_data
	end

	def calculate_mean
		mean = 0
		@test_data.each do |entry|
			mean += (entry[3].to_f - entry[2].to_f).abs
		end
		return mean / @test_data.length
	end

	def mean
		return @mean
	end
	
	def stdev
		return @stdev
	end

	def rms
		return (@mean**2 + @stdev**2)**(0.5)
	end


	def calculate_stdev
		num = 0
		@test_data.each do |entry|
			num += ((entry[3].to_f - entry[2].to_f).abs - @mean) ** 2
		end
		num = num / @test_data.length
		num = num ** (0.5)
		return num
	end
end

