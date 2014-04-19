require 'twitter'

class TwitterClient

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "dblsr1vNeFhXtEXzzsqzO2cos"
      config.consumer_secret     = "MMasTnclHx1rbJSOQhyiUI0Hwx7qRIJvULQIjZTAMKk28lvKvX"
    end
  end

  def find(movie = "captain america")
    @client.search(movie).take(100)
  end

end
