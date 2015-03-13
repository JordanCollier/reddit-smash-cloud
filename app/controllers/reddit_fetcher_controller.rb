class RedditFetcherController < ApplicationController

  def index
    reddit_fetcher = RedditFetcher.new
    @search_key = reddit_fetcher.search_key
    @comments = reddit_fetcher.comments
  end

end
