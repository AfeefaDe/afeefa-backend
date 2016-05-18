FactoryGirl.define do
  factory :user do

    factory :valid_user do
      email 'test@afeefa.de'
      password 'abc12346'

    end

  end

end
