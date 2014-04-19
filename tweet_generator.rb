require_relative 'twitter_client'
require_relative 'sentiment'

class TweetGenerator
  def self.generate_tweets(movie)
    @unscored_tweets = []
    TwitterClient.new.find(movie).each do |t|
      tweet = t.text
      @unscored_tweets << Tweet.from_tweet(tweet)
    end
    self.get_sentiment
  end

  def self.get_sentiment
    @scored_tweets = []
    @unscored_tweets.each do |tweet|
      @scored_tweets << Sentimentalizer.sentimentalize(tweet)
    end
    self.drop_neutrals
  end

  # strip neutral tweets and add up movie's score
  def self.drop_neutrals
    @non_neutral_tweets = @scored_tweets.map do |tweet|
      tweet unless tweet.value == 0
    end
    self.movie_total
  end

  def self.average(array)
    array.inject(:+)/array.length
  end

  def self.movie_total
    # puts @non_neutral_tweets
    scores = []
    @non_neutral_tweets.each do |tweet|
      next if tweet.nil?
      scores << tweet.score
    end

    @negs = scores.select { |score| score < 0 }

    @pos = scores.select { |score| score > 0 }
    reply_string = ""
    neg_rating = self.average(@negs).abs
    pos_rating = self.average(@pos)
    if neg_rating > pos_rating
      reply_string += "Twitterverse consensus: #{neg_rating} percent negative.\n"
    else
      reply_string += "Twitterverse consensus: #{pos_rating} percent positive.\n"
    end
    puts reply_string += "Representative tweets: \n"
    puts "\n"
    tweets = []
    10.times do
      tweet = @non_neutral_tweets.sample
      tweets << tweet unless tweet.nil?
    end

    tweets.each { |tweet| puts "#{tweet.content}\n" }

  end

end
