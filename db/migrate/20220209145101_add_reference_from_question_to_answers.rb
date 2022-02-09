class AddReferenceFromQuestionToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :answer, foreign_key: true, on_delete: :cascade
  end
end
