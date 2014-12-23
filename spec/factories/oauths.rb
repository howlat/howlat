FactoryGirl.define do
  factory :oauth, class: Hash do
    provider {  Identity::PROVIDERS.sample }
    uid { Time.zone.now.to_i.to_s }
    sequence(:info) { |n|
      {
        email: "person-#{n}@parley.com",
        name: "person-#{n}-name",
        nickname: "person-#{n}-nickname",
        first_name: "person-#{n}-firstname",
        last_name: "person-#{n}-lastname"
      }
    }
    trait :without_email do
      sequence(:info) { |n|
        {
          name: "person-#{n}-name",
          first_name: "person-#{n}-firstname",
          last_name: "person-#{n}-lastname"
        }
      }
    end

    trait :invalid do
      provider "wrong"
      uid nil
      info { {} }
    end

    initialize_with { attributes }
    factory :valid_oauth
    factory :valid_oauth_without_email, traits: [:without_email]
    factory :invalid_oauth, traits: [:invalid]
  end
end
