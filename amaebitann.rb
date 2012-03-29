# -*- encoding: UTF-8 -*-
require 'bundler/setup'
require 'twitter'
require_relative 'db'

class Amaebitann
  KYAPI = "☆(ゝω・　)v"

  def initialize
    Twitter.configure do |config|
      config.consumer_key       = 'FhaHrAkXtyYBHnC9cPJXNQ'
      config.consumer_secret    = 'FZD6x3s6stN7clBkDZX5VJgkZqA57MURWxkq7r5zsEo'
      config.oauth_token        = '539087161-U6iMhs3xumxiMOU3tXGhKQQe8Wx6udeKMnyc4qM6'
      config.oauth_token_secret = 'fFVhEVNAr6kYTLwOKxk2NdEMt0mb6HRfBNfb3eUycY'
    end
    
    @already_tweets = AmaebitannDB::AlreadyTweet.new
    @all_words      = AmaebitannDB::TweetWord.new.all_words
  end

  def tweet
    mentions = Twitter.mentions
    mentions.each do |mention|
      next unless @already_tweets.find_by_tweet( mention.id ).nil?
      post(mention, "  ｷｬﾋﾟ!", 1) 
      @already_tweets.create_tweet( mention.id ) 
    end
  end

  private
  def post mention, str, i
    begin
      Twitter.update("@#{mention.user.screen_name} #{@all_words.sample} #{KYAPI}#{str*i}")
    rescue Twitter::Error::Forbidden
      post(mention, str, i.next)
    end
  end
end

Amaebitann.new.tweet
