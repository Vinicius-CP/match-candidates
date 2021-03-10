require 'rails_helper'

describe CandidatesController, type: :controller do
  describe '#index' do
    context 'should get index' do
      it 'successfully with params' do
        get :index, params: { city: 'RJ', technology: 'Sass', experience: '1' }
        assert_response :success
      end
    end

    context 'should get index' do
      it 'successfully without' do
        get :index, params: { city: '', technology: '', experience: '' }
        assert_response :success
      end
    end
  end

  describe '#search' do
    context 'should get search' do
      it 'successfully' do
        get :search
        assert_response :success
      end
    end
  end
end
