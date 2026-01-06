require "test_helper"

class Admin::CommunitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_communities_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_communities_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_communities_destroy_url
    assert_response :success
  end
end
