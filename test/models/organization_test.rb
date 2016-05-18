require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  setup do
    @my_orga = Organization.new
  end

  test 'organization attributes' do
    nil_defaults = [:title, :description, :api_key, :logo]
    false_defaults = [:support_wanted, :api_access]
    (nil_defaults + false_defaults).each do |attr|
      assert @my_orga.respond_to?(attr), "orga does not respond to #{attr}"
    end
    nil_defaults.each do |attr|
      assert_equal nil, @my_orga.send(attr)
    end
    false_defaults.each do |attr|
      assert !@my_orga.send(attr)
      assert !@my_orga.send("#{attr}?")
    end
  end

  test 'save orga' do
    assert_no_difference 'Organization.count' do
      assert !@my_orga.save
    end

    @my_orga.title = '12345'
    assert_difference 'Organization.count' do
      assert @my_orga.save
    end
  end

  test 'organization title length' do
    @my_orga.title = '123'
    assert !@my_orga.valid?

    @my_orga = FactoryGirl.build(:organization)
    assert @my_orga.valid?
  end

end
