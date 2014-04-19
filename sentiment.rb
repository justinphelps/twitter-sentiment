require 'net/http'
require 'json'

class Sentimentalizer

  def self.sentimentalize(tweet_object)
    uri = URI.parse("http://sentiment.vivekn.com/api/text/")
    # remove quotes that would blow up text string API
    puts tweet_object.content
    normalized_tweet = tweet_object.content.gsub("\"","")
    result = Net::HTTP.post_form(uri, {"txt" => normalized_tweet})
    value = JSON.parse(result.body)
    pos_neg = 1 if value["result"]["sentiment"] == "Positive"
    pos_neg = 0 if value["result"]["sentiment"] == "Neutral"
    pos_neg = -1 if value["result"]["sentiment"] == "Negative"
    tweet_object.value = pos_neg if pos_neg != nil
    tweet_object.confidence = value["result"]["confidence"].to_i
    return tweet_object
  end

  def self.batch(tweet_array)
    sentiment_array =[0,0,0]
    tweet_array.each do |tweet|
      case sentiment(tweet)
        when 'Positive'
          sentiment_array[0] += 1
        when 'Neutral'
          sentiment_array[1] += 1
        when 'Negative'
          sentiment_array[2] += 1
      end
    end

    return "Positive: #{sentiment_array[0]} Neutral: #{sentiment_array[1]} Negative: #{sentiment_array[2]}"
  end

end

# tweet_array =[]
# tweet_array << "I love ice cream"
# tweet_array << "I hate ice cream"
# tweet_array << "Superman rules EVERYTHENG!!!!!"
# tweet_array << "Superman sucks big time!!!"
# tweet_array << "Batman is a bomb!!!!!"
# tweet_array << "Godzilla Incredible New TV Spot For GODZILLA Released; Nature Has An Order"
# tweet_array << "What if Godzilla is the best movie ever...?"
# tweet_array << "9 reasons Godzilla is king of the movie monsters"
# tweet_array << "Did Captain America Have a Brother Who Died at Pearl Harbor?"
# tweet_array <<  "Black Widow can handle the emotional weight of being a lead character."

# tweet_array.each do |tweet|
#   puts Sentiment.sentiment(tweet) + ": " + tweet
# end
# puts Sentiment.batch(tweet_array)
