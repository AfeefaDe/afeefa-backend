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

      after(:build) do |user|
        user.roles << Role.new(title: Role::ORGA_MEMBER, orga: build(:orga), user: user)
      end

    end

    after(:create) do |user|
      user.orgas.map(&:save!)
    end

  end
end
