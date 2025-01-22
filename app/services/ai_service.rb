require 'openai'

class AiService
  class RateLimitError < StandardError; end
  MAX_RETRIES = 3
  BASE_WAIT_TIME = 10  # Increased base wait time

  def self.invoke_agent(query)
    retries = 0
    begin
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
      
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "You are a helpful assistant" },
            { role: "user", content: query }
          ],
          max_tokens: 150,
          temperature: 0.7
        }
      )
      
      response.dig("choices", 0, "message", "content").to_s.strip
    rescue Faraday::TooManyRequestsError => e
      retries += 1
      if retries <= MAX_RETRIES
        wait_time = BASE_WAIT_TIME * retries  # Linear backoff: 10, 20, 30 seconds
        Rails.logger.warn("Rate limit hit (#{retries}/#{MAX_RETRIES}). Waiting #{wait_time} seconds...")
        sleep(wait_time)
        retry
      else
        Rails.logger.error("Rate limit exceeded. Response: #{e.response&.body}")
        raise RateLimitError, "Please wait a few minutes before trying again"
      end
    rescue StandardError => e
      Rails.logger.error("OpenAI Error: #{e.class} - #{e.message}")
      raise "API Error: #{e.message}"
    end
  end
end