require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
   @my_Lang = Language.new
  end

  #...

  test "save lang" do
    assert_no_difference 'Language.count' do
      assert !@my_Lang.save
    end

    @my_Lang.code = 'abc'
    assert_difference 'Language.count' do
      assert @my_Lang.save
    end
  end

  test "language code length" do
    @my_Lang.code = 'a'
    assert !@my_Lang.valid?

    #@my_Lang = FactoryGirl.build(:language)
    #assert @my_Lang.valid?
  end

  should 'do_something' do
    assert_equal 'do_something', @my_Lang.do_something
  end

end
