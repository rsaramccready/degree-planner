require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_session_path
    assert_response :success
    
  end

  test "should get create" do
    user = users(:austin)
    post session_path, params: { email: user.email, password: "tandahackathon" }
    assert_redirected_to logged_in_path
  end

  test "should get destroy" do
    delete session_path
    assert_redirected_to new_session_path
  end
end
