require "test_helper"

class AiAgentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ai_agents_new_url
    assert_response :success
  end

  test "should get invoke_agent" do
    get ai_agents_invoke_agent_url
    assert_response :success
  end

  test "should get index" do
    get ai_agents_index_url
    assert_response :success
  end
end
