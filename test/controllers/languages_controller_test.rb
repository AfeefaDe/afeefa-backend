require 'test_helper'

class LanguagesControllerTest < ActionController::TestCase
  setup do
    @language = FactoryGirl.create(:language)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:languages)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create language' do
    assert_difference('Language.count') do
      post :create, language: { code: @language.code, rtl: @language.rtl }
    end

    assert_redirected_to language_path(assigns(:language))
  end

  test 'should handle create language error' do
    Language.any_instance.stubs(:save).returns(false)

    assert_no_difference('Language.count') do
      post :create, language: { code: @language.code, rtl: @language.rtl }
    end

    assert_response :success
    assert_template :new
  end

  test 'should show language' do
    get :show, id: @language
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @language
    assert_response :success
  end

  test 'should update language' do
    assert_no_difference('Language.count') do
      patch :update, id: @language, language: { code: @language.code, rtl: @language.rtl }
    end

    assert_redirected_to language_path(assigns(:language))
  end

  test 'should handle update language error' do
    Language.any_instance.stubs(:save).returns(false)

    assert_no_difference('Language.count') do
      patch :update, id: @language, language: { code: @language.code, rtl: @language.rtl }
    end

    assert_response :success
    assert_template :edit
  end

  test 'should destroy language' do
    assert_difference('Language.count', -1) do
      delete :destroy, id: @language
    end

    assert_redirected_to languages_path
  end
end
