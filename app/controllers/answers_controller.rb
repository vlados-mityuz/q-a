class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created'
    else
      @question.reload
      render "questions/show"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: "Your answer was successfully deleted."
    else
      redirect_to question_path(@answer.question)
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
