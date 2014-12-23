# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room_membership do
    room
    user
    room_hidden false
  end
end
