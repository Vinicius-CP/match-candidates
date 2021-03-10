require 'rails_helper'

describe Candidates::Filter, type: :service do
  describe '#filter' do
    before do
      candidate_1
      candidate_2
      candidate_3
      candidate_4
    end

    let(:candidate_1) do 
      Candidate.create(city: 'rio de janeiro - rj',  experience: '5-6',
                    technologies: [{ name: 'jquery', is_main_tech: true }])
    end

    let(:candidate_2) do 
       Candidate.create(city: 'rio branco - ac',  experience: '3-4',
                    technologies: [{ name: 'sass', is_main_tech: true }])
    end

    let(:candidate_3) do 
      Candidate.create(city: 'são paulo - sp', experience: '2-3',
                    technologies: [{ name: 'sass', is_main_tech: false }])
    end

    let(:candidate_4) do 
      Candidate.create(city: 'são paulo - sp', experience: '12+',
                    technologies: [{ name: 'sass', is_main_tech: true }])
    end

    let(:candidate_params) do 
      { city: 'sp', technology: 'sass', experience: '4 anos ou mais' }
    end

    let(:custom_candidate_params) do
      { city: '', technology: '', experience: '' }
    end

    context 'return none candidate if none parameter' do
      it 'successfully' do
        result = described_class.new(custom_candidate_params).filter

        expect(result.count).to eq 0
      end
    end

    context 'match the best candidates with all the supplied parameters' do
      it 'successfully' do
        result = described_class.new(candidate_params).filter

        expect(result.count).to eq 1
        expect(result[0].id).to eq candidate_4.id
        expect(result[0].city).to eq candidate_4.city
        expect(result[0].experience).to eq candidate_4.experience
        expect(result[0].technologies).to eq candidate_4.technologies
      end
    end

    context 'match the best candidates with city parameter' do
      it 'successfully' do
        custom_candidate_params.merge!(city: 'são paulo')
        result = described_class.new(custom_candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 2
        expect(best_matches).to include(candidate_3.id, candidate_4.id)
        expect(best_matches).not_to include(candidate_1.id, candidate_2.id)
      end
    end

    context 'match the best candidates with technology parameter' do
      it 'successfully' do
        custom_candidate_params.merge!(technology: 'sass')
        result = described_class.new(custom_candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 3
        expect(best_matches).to include(
          candidate_2.id, candidate_3.id, candidate_4.id
        )
        expect(best_matches).not_to include(candidate_1.id)
      end
    end

    context 'match the best candidates with experience parameter' do
      it 'successfully' do
        custom_candidate_params.merge!(experience: '3 ou mais')
        result = described_class.new(custom_candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 3
        expect(best_matches).to include(
          candidate_1.id, candidate_2.id, candidate_4.id
        )
        expect(best_matches).not_to include(candidate_3.id)
      end
    end

    context 'match the best candidates with city and technology parameters' do
      it 'successfully' do
        candidate_params.merge!(city: 'rio branco', experience: '')
        result = described_class.new(candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 1
        expect(best_matches).to include(candidate_2.id)
        expect(best_matches).not_to include(
          candidate_1.id, candidate_3.id, candidate_4.id
        )
      end
    end

    context 'match the best candidates with city and experience parameters' do
      it 'successfully' do
        candidate_params.merge!(technology: '')
        result = described_class.new(candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 1
        expect(best_matches).to include(candidate_4.id)
        expect(best_matches).not_to include(
          candidate_1.id, candidate_2.id, candidate_3.id
        )
      end
    end

    context 'match the best candidates with experience and technology parameters' do
      it 'successfully' do
        candidate_params.merge!(city: '')
        result = described_class.new(candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 1
        expect(best_matches).to include(candidate_4.id)
        expect(best_matches).not_to include(
          candidate_1.id, candidate_2.id, candidate_3.id
        )
      end
    end

    context 'match only with 12+ candidates if experience greather than 12' do
      it 'successfully' do
        custom_candidate_params.merge!(experience: '20')
        result = described_class.new(candidate_params).filter
        best_matches = result.map(&:id)

        expect(result.count).to eq 1
        expect(best_matches).to include(candidate_4.id)
        expect(best_matches).not_to include(
          candidate_1.id, candidate_2.id, candidate_3.id
        )
      end
    end
  end
end
