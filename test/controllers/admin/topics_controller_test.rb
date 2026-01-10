# frozen_string_literal: true

require "test_helper"

class Admin::TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_topics_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_topics_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_topics_destroy_url
    assert_response :success
  end
end
