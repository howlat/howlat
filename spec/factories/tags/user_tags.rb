# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory 'tags/user_tag' do
    name { "user:#{Random.new.rand(1..50000)}" }
    type 'user_tag'
    trait :everyone_tag do
      name "user:everyone"
      type 'user_tag'
    end
  end
end
