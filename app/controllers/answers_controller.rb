class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :find_answer, only: [:update, :destroy]
  before_action :answer_question, only: [:update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    flash.now[:notice] = 'Answer successfully created' if @answer.save
  end

  def update
    return unless current_user.author_of?(@answer)

    @answer.update(answer_params)
    flash.now[:notice] = 'Answer successfully updated'
  end

  def destroy
    return unless current_user.author_of?(@answer)

    @answer.destroy
    flash.now[:notice] = 'Answer successfully deleted'
  end

  private

  def answer_question
    @question = @answer.question
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
