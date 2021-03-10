require 'rails_helper'

RSpec.describe Candidate, type: :model do
  context 'with valid and filled attributes' do
    let(:candidate) do Candidate.create(
        city: 'RJ',
        technologies: { name: 'JS', is_main_tech: true },
        experience: '1-2'
      )
    end

    it { expect(candidate).to be_valid }
    it { expect(candidate).to be_a Candidate }
  end

  context 'with invalid attributes' do
    let(:candidate) do Candidate.create(
        city: '',
        technologies: '',
        experience: ''
      )
    end

    it { expect(candidate).to be_invalid }
  end
end
