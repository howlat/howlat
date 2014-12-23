# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    token { SecureRandom.hex }
    room_id nil
    email nil
  end
end
