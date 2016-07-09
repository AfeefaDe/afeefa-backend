require 'test_helper'

class OrgaTest < ActiveSupport::TestCase

  setup do
    @my_orga = Orga.new
  end

  test 'orga attributes' do
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
    assert_no_difference 'Orga.count' do
      assert !@my_orga.save
    end

    @my_orga.title = '12345'
    assert_difference 'Orga.count' do
      assert @my_orga.save
    end
  end

  test 'orga title length' do
    @my_orga.title = '123'
    assert !@my_orga.valid?

    @my_orga = build(:orga)
    assert @my_orga.valid?
  end

  context 'As admin' do
    setup do
      @admin = create(:admin)
      @user = create(:user)
    end

    should 'I want to add a new member to my orga' do
      orga = @admin.orgas.first

      assert_difference('orga.users.count') do
        orga.add_new_member(new_member: @user, admin: @admin)
      end

      assert_equal(orga, @user.reload.orgas.first)
    end

    should 'I must not add a new member to a foreign orga' do
      orga = create(:another_orga)

      assert_no_difference('@user.orgas.count') do
        assert_no_difference('orga.users.count') do
          assert_raise CanCan::AccessDenied do
            orga.add_new_member(new_member: @user, admin: @admin)
          end
        end
      end
    end

    should 'I must not add the same member to my orga again' do
      orga = @admin.orgas.first

      orga.add_new_member(new_member: @user, admin: @admin)

      assert_no_difference('orga.users.count') do
        assert_no_difference('@user.orgas.count') do
          assert_raise UserIsAlreadyMemberException do
            orga.add_new_member(new_member: @user, admin: @admin)
          end
        end
      end

      assert_no_difference('orga.users.count') do
        assert_no_difference('@user.orgas.count') do
          assert_raise UserIsAlreadyMemberException do
            orga.add_new_member(new_member: @admin, admin: @admin)
          end
        end
      end

    end
  end

end