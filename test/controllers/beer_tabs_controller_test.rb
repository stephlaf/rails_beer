# frozen_string_literal: true

require 'test_helper'

class BeerTabsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get beer_tabs_index_url
    assert_response :success
  end

  test 'should get show' do
    get beer_tabs_show_url
    assert_response :success
  end

  test 'should get new' do
    get beer_tabs_new_url
    assert_response :success
  end

  test 'should get create' do
    get beer_tabs_create_url
    assert_response :success
  end

  test 'should get edit' do
    get beer_tabs_edit_url
    assert_response :success
  end

  test 'should get update' do
    get beer_tabs_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get beer_tabs_destroy_url
    assert_response :success
  end
end
