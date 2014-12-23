# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    room_id nil
    name "MyString"
    url "MyString"
    state 1
    type ""
  end
end
