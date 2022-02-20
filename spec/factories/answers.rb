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

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |answer|
        answer.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end
  end
end
