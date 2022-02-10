FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "Text#{n}"
    end

    association :question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
