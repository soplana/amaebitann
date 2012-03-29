# gem install mongo bson_ext json
require 'bundler/setup'
require 'mongo'
require 'uri'
require 'json'


module AmaebitannDB
  class Base
    MONGOHQ_URL="mongodb://amaebitann:mogumogu@staff.mongohq.com:10037/amaebitann"
    def self.get_connection
      return @db if @db
      db      = URI.parse(MONGOHQ_URL)
      db_name = db.path.gsub(/^\//, '')
      @db     = Mongo::Connection.new(db.host, db.port).db(db_name)
      @db.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
      return @db
    end

    def initialize collection_name
      @colle = Base.get_connection.collection(collection_name)
    end
    
    def collection
      return @colle
    end
  end

  class AlreadyTweet < AmaebitannDB::Base
    def initialize
      super("already_tweets")
    end

    def create_tweet id
      collection.insert(tweet_id: id)
    end
    
    def find_by_tweet id
      collection.find(tweet_id: id).first || nil
    end
  end
end
