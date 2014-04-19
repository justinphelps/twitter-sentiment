# class Sentiment
#   attr_accessor :value, :confidence
#   def initialize(value, confidence)
#     @value = value
#     @confidence = confidence
#   end

#   def score
#     confidence * value
#   end
# end
require_relative "tweet_generator"

class Tweet #done?
  attr_accessor :value, :confidence
  attr_reader :content, :sentiment

  def initialize(args)
    @content = args[:text]
    @sentiment = args[:sentiment]
    @value = nil
    @confidence = nil
  end

  def self.from_tweet(text, sentiment = nil)
    # raise ArgumentError unless sentiment.is_a? Sentiment
    self.new(text: text, sentiment: sentiment)
  end

  def score
    confidence * value.floor
  end
end

# ---------------------------

class Viewer

  def self.run!
    puts "Please enter a movie:"
    input = gets.chomp
    puts "\n"
    puts TweetGenerator.generate_tweets(input)
  end

end

Viewer.run!

# iterate over scored tweets, get rid of zeros before making
# total and using info to generate string for user

