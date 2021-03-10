require 'rails_helper'

describe Candidates::FillDatabase, type: :service do
  describe '.fill' do
    context 'should fill database with candidates' do
      before { described_class.fill }

      let(:candidates_quantity) { Candidate.count }
      let(:expected_instances) { 100 }

      it 'the database is expected not to be empty' do
        expect(candidates_quantity).to eq expected_instances
      end
    end
  end
end
