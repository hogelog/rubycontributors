require "net/http"
require "uri"
require "json"

class Github
  RETRY_LIMIT = 5
  RETRY_SLEEP = 10
  RANDOM_RETRY_SLEEP = 10
  SLEEP = 1
  RANDOM_SLEEP = 2

  def self.fetch_login(sha, name)
    try = 0
    begin
      try += 1
      res = Net::HTTP.get_response(URI.parse("https://github.com/ruby/ruby/commit/#{sha}.json"))
      res.value
      sleep SLEEP + rand(RANDOM_SLEEP)
      data = JSON.parse(res.body, symbolize_names: true)
      author = data[:payload][:commit][:authors].find {|author| author[:displayName] == name }
      return author && author[:login]
    rescue Net::HTTPFatalError => e
      if try <= RETRY_LIMIT
        sleep RETRY_SLEEP + rand(RANDOM_RETRY_SLEEP)
        retry
      else
        raise e
      end
    end
  end
end 
