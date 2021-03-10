require 'rails_helper'

describe Api::GetData, type: :service do
  describe '#call' do
    context 'should return parsed data' do
      it 'successfully' do
        url = 'https://geekhunter-recruiting.s3.amazonaws.com/code_challenge.json'
        candidates_response = described_class.new(url).call

        expect(candidates_response).to be_kind_of(Hash)
        expect(candidates_response).to have_key(:candidates)
        expect(candidates_response[:candidates]).not_to be nil
      end
    end
  end
end
