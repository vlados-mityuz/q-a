class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: "User"
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def other_answers
    self.answers.where.not(id: self.best_answer_id)
  end
end
