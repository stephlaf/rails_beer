# frozen_string_literal: true

require 'test_helper'

class TempBeersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get temp_beers_index_url
    assert_response :success
  end

  test 'should get show' do
    get temp_beers_show_url
    assert_response :success
  end

  test 'should get new' do
    get temp_beers_new_url
    assert_response :success
  end

  test 'should get create' do
    get temp_beers_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get temp_beers_destroy_url
    assert_response :success
  end
end
