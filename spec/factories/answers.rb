FactoryBot.define do
  factory :answer do
    body { "MyText" }
    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
