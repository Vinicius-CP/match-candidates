class Candidates::Filter
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def filter
    better_match
  end

  private

  def better_match
    case
    when city.empty? && technology.empty? && experience.empty?
      []
    when city.present? && technology.present? && experience.present?
      filter_by_city_technology_experience.first(5)
    when city.present? && technology.present? && experience.empty?
      filter_by_city_technology.first(5)
    when city.present? && technology.empty? && experience.present?
      filter_by_city_experience.first(5)
    when city.empty? && technology.present? && experience.present?
      filter_by_technology_experience.first(5)
    when city.empty? && technology.empty? && experience.present?
      filter_by_experience.first(5)
    when city.empty? && technology.present? && experience.empty?
      filter_by_technology.first(5)
    when city.present? && technology.empty? && experience.empty?
      filter_by_city.first(5)
    end
  end

  def filter_by_city
    Candidate.where('city LIKE ?', "%#{city}%")
  end

  def filter_by_technology
    return filter_by_main_tech(false) if filter_by_main_tech(true).empty?
    filter_by_main_tech(true).or(filter_by_main_tech(false))
  end

  def filter_by_main_tech(boolean)
    Candidate
      .where('technologies @> ?', [
        { name: technology, is_main_tech: boolean }
      ].to_json)
  end

  def filter_by_experience
    check_experience_time

    candidates = Candidate.where(
      'experience LIKE ?', "#{till_time(experience_time)}"
    )
    return candidates if experience_time >= 12
  
    more_experience = experience_time + 1
    loop do
      candidates += Candidate.where(
        'experience LIKE ?', "#{till_time(more_experience)}"
      )
      more_experience += 1
    break if more_experience > 12 || candidates.count >= 5
    end

    candidates
  end

  def check_experience_time
    params[:experience] = '12' if experience_time >= 12
  end

  def till_time(time)
    time != 12 ? "#{time}-#{time + 1}" : '12+'
  end

  def experience_time
    experience.split(/[^\d]/).join.to_i
  end

  def filter_by_city_experience
    check_experience_time
    return_empty_city
    
    by_city_experience = 
      filter_by_city.where('experience LIKE ?', "#{till_time(experience_time)}")
    return by_city_experience if experience_time >= 12
    more_experience = experience_time + 1

    loop do
      by_city_experience += filter_by_city.where(
        'experience LIKE ?', "#{till_time(more_experience)}"
      )
      more_experience += 1
    break if more_experience > 12 || by_city_experience.count >= 5
    end

    by_city_experience
  end

  def return_empty_city
    return filter_by_city if filter_by_city.empty?
  end

  def filter_by_technology_experience
    return_empty_technology
    check_experience_time
    by_technology = filter_by_technology

    by_technology_experience = 
      by_technology.where('experience LIKE ?', "#{till_time(experience_time)}")
    return by_technology_experience if experience_time >= 12
    more_experience = experience_time + 1

    loop do
      by_technology_experience += by_technology.where(
        'experience LIKE ?', "#{till_time(more_experience)}"
      )
      more_experience += 1
    break if more_experience > 12 || by_technology_experience.count >= 5
    end

    by_technology_experience
  end

  def return_empty_technology
    return filter_by_technology if filter_by_technology.empty?
  end

  def filter_by_city_technology
    by_city = filter_by_city
    return by_city if by_city.empty?

    by_city_main_technology = by_city.where('technologies @> ?', [
      { name: technology, is_main_tech: true }
    ].to_json)

    return by_city_main_technology if by_city_main_technology.count >= 5

    by_city_technology = by_city_main_technology.or(by_city.where(
      'technologies @> ?', [{ name: technology, is_main_tech: false }].to_json)
    )

    by_city_technology.empty? ? by_city : by_city_technology
  end

  def filter_by_city_technology_experience
    return_empty_city_technology
    check_experience_time
    by_city_technology = filter_by_city_technology

    by_city_technology_experience = by_city_technology.where(
      'experience LIKE ?', "#{till_time(experience_time)}"
    )
    return by_city_technology_experience if experience_time >= 12
    more_experience = experience_time + 1

    loop do
      by_city_technology_experience += by_city_technology.where(
        'experience LIKE ?', "#{till_time(more_experience)}"
      )
      more_experience += 1
    break if more_experience > 12 || by_city_technology_experience.count >= 5
    end

    by_city_technology_experience
  end

  def return_empty_city_technology
    return filter_by_city_technology if filter_by_city_technology.empty?
  end

  def city
    params[:city].downcase
  end

  def technology
    params[:technology].downcase
  end

  def experience
    params[:experience].downcase
  end
end
