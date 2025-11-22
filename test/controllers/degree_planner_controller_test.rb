require "test_helper"

class DegreePlannerControllerTest < ActionDispatch::IntegrationTest
  test "should get step1" do
    get degree_planner_step1_url
    assert_response :success
  end

  test "should get step2" do
    get degree_planner_step2_url
    assert_response :success
  end

  test "should get plan" do
    get degree_planner_plan_url
    assert_response :success
  end
end
