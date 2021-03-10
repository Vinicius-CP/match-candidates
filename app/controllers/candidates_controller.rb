class CandidatesController < ApplicationController
  def index
    @candidates = Candidates::Filter.new(candidate_params).filter
  end

  def search; end

  private

  def candidate_params
    params.permit(:city, :technology, :experience)
  end
end
