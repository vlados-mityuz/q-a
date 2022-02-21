require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_file) }
  let(:answer) { create(:answer, :with_file) }

  describe 'DELETE #destroy' do
    context 'Author of the question' do
      let(:user) { question.author }

      before { login(user) }

      it 'deletes the attached file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to change(question.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author of the answer' do
      let(:user) { answer.author }

      before { login(user) }

      it 'deletes the attached file' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to change(answer.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Is not author of the question' do

      it 'tries to delete file' do
        login(user)
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to_not change(question.files, :count)
      end
    end

    context 'Is not author of the answer' do

      it 'tries to delete file' do
        login(user)
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to_not change(answer.files, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to_not change(question.files, :count)
      end

      it 'tries to delete question' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }
          .to_not change(answer.files, :count)
      end
    end
  end
end