require 'openai'

class AiService
  def self.invoke_agent(query)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    response = client.completions(engine: 'davinci-codex', parameters: { prompt: query, max_tokens: 150 })
    response['choices'].first['text'].strip
  end
end