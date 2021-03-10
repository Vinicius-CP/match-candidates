class Api::GetData
  require 'open-uri'
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call
    JSON.parse(open(url).read, symbolize_names: true)
  end
end
