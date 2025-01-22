class AiAgentsController < ApplicationController
  def new
  end

  def invoke_agent
    user_query = params[:query]
    ai_response = AiService.invoke_agent(user_query)

    # save the query and response to the database
    Query.create(user_query: user_query, ai_response: ai_response)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path, notice: "Query sent" }
    end
  end

  def index
    @queries = Query.all
  end
end
