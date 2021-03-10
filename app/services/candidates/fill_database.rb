class Candidates::FillDatabase
  def self.fill
    new.fill
  end

  def fill
    create_objects
  end
  
  private

  def create_objects
    get_data[:candidates].map do |candidate|
      format_candidate(candidate)
      Candidate.create!(candidate)
    end
  end

  def get_data
    Api::GetData.new(
      'https://geekhunter-recruiting.s3.amazonaws.com/code_challenge.json'
    ).call
  end

  def format_candidate(candidate)
    candidate[:city].downcase!
    candidate[:experience].sub!(' years', '')
    candidate[:technologies].each { |tech| tech[:name].downcase! }
  end
end
