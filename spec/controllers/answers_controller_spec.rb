require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'if current user is the author of answer' do
      let!(:answer) { create(:answer) }
      let(:user) { answer.author }

      before { login(user) }
      
      context 'with valid attributes' do
        it 'edits the answer' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders create template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'if current user is not the author of answer' do
      let!(:answer) { create(:answer) }
      let(:user) { create(:user) }

      before { login(user) }

      it 'tries to update answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'if current user is the author of answer' do
      let!(:answer) { create(:answer) }
      let(:user) { answer.author }

      before { login(user) }
      
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders delete' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
        expect(flash[:notice]).to be_present
      end
    end

    context 'if current user is not the author of answer' do
      let!(:answer) { create(:answer) }
      let (:user) { create(:user) }

      before { login(user) }

      it 'doesnt delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #best_answer' do
    context 'if current user is the author of question' do
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }

      before { login(user) }

      it 'does set answer as the best' do
        post :best_answer, params: { id: answer }, format: :js
        question.reload
        expect(question.best_answer).to eq answer
      end

      it 'renders template best answer' do
        post :best_answer, params: { id: answer }, format: :js
        expect(response).to render_template :best_answer
      end
    end

    context 'if current user is not the author of question' do
      let(:user) { create(:user) }

      before { login(user) }

      it 'doesnt set answer as the best' do
        post :best_answer, params: { id: answer }, format: :js
        question.reload
        expect(question.best_answer).to_not eq answer
      end
    end
  end
end