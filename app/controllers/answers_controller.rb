class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :best_answer]
  before_action :find_answer, only: [:update, :destroy, :best_answer]
  before_action :answer_question, only: [:update, :destroy, :best_answer]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    flash.now[:notice] = 'Answer successfully created' if @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Answer successfully updated'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer successfully deleted'
    end
  end

  def best_answer
    if current_user.author_of?(@question)
      @answer.mark_as_best

      @best_answer = @question.best_answer
      flash.now[:notice] = 'Best answer was chosen'
    end
  end

  private

  def answer_question
    @question = @answer.question
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
