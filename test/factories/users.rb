FactoryGirl.define do
  factory :user do
    email 'test@afeefa.de'
    forename 'Max'
    surname 'Mustermann'

    #todo: remove required password from device
    password 'abc12346'

    factory :admin do

      email 'admin@afeefa.de'

      after(:build) do |user|
        #todo: make easier... if possible
        user.roles << Role.new(title: Role::ORGA_ADMIN, orga: build(:orga), user: user)
      end
    end

    factory :member do

      email 'member@afeefa.de'

      transient do
        orga nil
      end

      after(:build) do |member, evaluator|
        member.roles << Role.new(title: Role::ORGA_MEMBER, orga: evaluator.orga, user: member)
      end
    end

    after(:create) do |user|
      user.orgas.map(&:save!)
    end

  end
end
