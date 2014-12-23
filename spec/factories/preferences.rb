# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :preferences do
    user nil
    audio_volume 1
    audio_notifications "MyString"
    desktop_notifications "MyString"
    email_notifications false
  end
end
