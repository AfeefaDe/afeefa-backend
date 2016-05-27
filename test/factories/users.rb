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
        user.roles << Role.new(title: Role::ORGA_ADMIN, organization: build(:organization), user: user)
      end
    end

  end

end
