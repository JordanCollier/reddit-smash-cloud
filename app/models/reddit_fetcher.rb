class RedditFetcher

  attr_accessor :comments

  def initialize
    @reddit = Faraday.new(:url => 'https://www.reddit.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    @comments = []
  end

  def smashbros
    response = @reddit.get do |req|
      req.url "/r/smashbros/comments/2gbctz/hi_what_button_do_i_press_for_the_final_smash_in.json"
      req.headers['Reddit-Token'] = ENV["REDDIT_TOKEN"]
      req.headers['Content-Type'] = 'application/json'
    end

    JSON.parse(response.body)
  end

  def first_layer
    0.upto(first_layer_length-1) do |i|
      @comments << smashbros[1]["data"]["children"][i]["data"]["body"]
    end
  end

  def first_layer_length
    smashbros[1]["data"]["children"].length
  end

  def most_common
    ## all comments
 ## create new array that is each word
 ## build a hash where default value is 0
 ## add each word as a key to the hash while incrementing one.
 ## return the key with the highest value.
    @comment_count = @comments.join(" ").downcase.split(" ").each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
  end

  def largest_hash_key
   ## return the key with the highest value.
   array = ["the", "and", "for", "but", "is", "that", "this", "than", "from",
     "if", "where", "us", "me", "i", "you", "them", "a", "an",
     "they", "or", "so", "yet", "nor", "either", "neither", "as", "to",
     "did", "got", "of", "he", "she", "has", "have", "their", "there", "they're",
     "are", "am", "who", "his", "hers", "how", "when", "why", "all", "because",
     "in", "on", "though", "thus", "therefore"]
   array.each do |x|
     @comment_count.delete(x)
   end
   word = @comment_count.max_by{|k, v| v}[0]
 end

 def search_key
   @comments << first_layer
   most_common
   largest_hash_key
 end

end
