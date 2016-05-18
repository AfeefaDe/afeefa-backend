require 'test_helper'

class MarketEntriesControllerTest < ActionController::TestCase
  setup do
    @market_entry = FactoryGirl.create(:market_entry)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:market_entries)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create market_entry' do
    assert_difference('MarketEntry.count') do
      post :create, market_entry: { assigned_at: @market_entry.assigned_at, availabilty: @market_entry.availabilty, pending_since: @market_entry.pending_since, requested_At: @market_entry.requested_At, type: @market_entry.type, way: @market_entry.way }
    end

    assert_redirected_to market_entry_path(assigns(:market_entry))
  end

  test 'should handle create market_entry error' do
    MarketEntry.any_instance.stubs(:save).returns(false)

    assert_no_difference('MarketEntry.count') do
      post :create, market_entry: { assigned_at: @market_entry.assigned_at, availabilty: @market_entry.availabilty, pending_since: @market_entry.pending_since, requested_At: @market_entry.requested_At, type: @market_entry.type, way: @market_entry.way }
    end

    assert_response :success
    assert_template :new
  end

  test 'should show market_entry' do
    get :show, id: @market_entry
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @market_entry
    assert_response :success
  end

  test 'should update market_entry' do
    assert_no_difference('MarketEntry.count') do
      patch :update, id: @market_entry, market_entry: { assigned_at: @market_entry.assigned_at, availabilty: @market_entry.availabilty, pending_since: @market_entry.pending_since, requested_At: @market_entry.requested_At, type: @market_entry.type, way: @market_entry.way }
    end

    assert_redirected_to market_entry_path(assigns(:market_entry))
  end

  test 'should handle update market_entry error' do
    MarketEntry.any_instance.stubs(:save).returns(false)

    assert_no_difference('MarketEntry.count') do
      patch :update, id: @market_entry, market_entry: { assigned_at: @market_entry.assigned_at, availabilty: @market_entry.availabilty, pending_since: @market_entry.pending_since, requested_At: @market_entry.requested_At, type: @market_entry.type, way: @market_entry.way }
    end

    assert_response :success
    assert_template :edit
  end

  test 'should destroy market_entry' do
    assert_difference('MarketEntry.count', -1) do
      delete :destroy, id: @market_entry
    end

    assert_redirected_to market_entries_path
  end
end
