require "net/http"
require "uri"

class Github
  RETRY_LIMIT = 3
  RETRY_SLEEP = 10
  SLEEP = 1

  def self.fetch_login(sha)
    try = 0
    begin
      try += 1
      res = Net::HTTP.get_response(URI.parse("https://github.com/ruby/ruby/commit/#{sha}"))
      res.value
      sleep SLEEP
      elem = res.body.match(%r[<div[^>]*data-testid="author-link"[^>]*><a[^>]*>(.*?)</a></div>])
      return elem && elem[1]
    rescue Net::HTTPFatalError => e
      if try <= RETRY_LIMIT
        sleep RETRY_SLEEP
        retry
      else
        raise e
      end
    end
  end
end 
