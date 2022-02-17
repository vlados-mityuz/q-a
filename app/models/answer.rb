class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true

  def mark_as_best
    question.update(best_answer_id: self.id)
  end
end
