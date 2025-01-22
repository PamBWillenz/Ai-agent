class AiAgentsController < ApplicationController
  def new
  end

  def invoke_agent
    user_query = params[:query]
    begin
      @ai_response = AiService.invoke_agent(user_query)
      Query.create(user_query: user_query, ai_response: @ai_response)
      
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Query processed successfully" }
      end
    rescue StandardError => e
      error_message = e.message
      Rails.logger.error("AI Agent Error: #{error_message}")
      
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("response_frame", 
            partial: "error", 
            locals: { message: error_message })
        }
        format.html { redirect_to root_path, alert: error_message }
      end
    end
  end

  def index
    @queries = Query.all
  end
end
