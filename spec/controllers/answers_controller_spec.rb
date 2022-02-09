require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attrubutes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attrubutes' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'if current user is the author of answer' do
      let!(:answer) { create(:answer) }
      let (:user) { answer.author }

      before { login(user) }
      
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to assigns(:question)
        expect(flash[:notice]).to be_present
      end
    end

    context 'if current user is not the author of answer' do
      let!(:answer) { create(:answer) }
      let (:user) { create(:user) }

      before { login(user) }

      it 'doesnt delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { params: { id: answer } }
        expect(response).to redirect_to assigns(:question)
        expect(flash[:notice]).to be_present
      end
    end
  end
end