FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after(:create) do |q|
        create_list(:answer, 5, question_id: q.id, author: q.author )
      end
    end

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |question|
        question.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end
  end
end
