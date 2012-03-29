# -*- encoding: UTF-8 -*-
require 'twitter'


class Amaebitann
  KYAPI = "☆(ゝω・　)v"
  TWEET = ["びたんびたん！", "ほうほうそれでそれで？", "おはよう！", "それサバンナでも同じ事言えるの？", "ちゅっちゅ", "ありがとう！"]

  def initialize
    Twitter.configure do |config|
      config.consumer_key       = 'FhaHrAkXtyYBHnC9cPJXNQ'
      config.consumer_secret    = 'FZD6x3s6stN7clBkDZX5VJgkZqA57MURWxkq7r5zsEo'
      config.oauth_token        = '539087161-U6iMhs3xumxiMOU3tXGhKQQe8Wx6udeKMnyc4qM6'
      config.oauth_token_secret = 'fFVhEVNAr6kYTLwOKxk2NdEMt0mb6HRfBNfb3eUycY'
    end
  end

  #暫定的にファイルでツイート管理
  def tweet
    mentions       = Twitter.mentions
    already_tweets = get_already_tweets
    already_file   = open("already_file", "w")
    
    mentions.each do |mention|
      post(mention, "  ｷｬﾋﾟ!", 1) unless already_tweets.include?(mention.id)
      already_file.write("#{mention.id}\n")
    end
    already_file.close
  end

  private
  def get_already_tweets
    already_tweets = []
    open("already_file","r").each{|f| already_tweets << f.strip.to_i}
    return already_tweets
  end

  def post mention, str, i
    begin
      Twitter.update("@#{mention.user.screen_name} #{TWEET.sample} #{KYAPI}#{str*i}")
    rescue Twitter::Error::Forbidden
      post(mention, str, i.next)
    end
  end
end

Amaebitann.new.tweet
