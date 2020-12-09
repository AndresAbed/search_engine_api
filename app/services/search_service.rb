class SearchService
  def initialize(params)
    @engine = params[:engine]
    @query = params[:query]
    @results = []
  end

  def perform_search
    @engine.each do |el|
      case el
      when "google"
        google(@query)
      when "bing"
        bing(@query)
      end
    end
    return @results
  end

  def google(query)
    params = { cx: ENV["google_cx"], key: ENV["google_access_key"], q: @query }

    response = JSON.parse(HTTParty.get(ENV["google_url"], {query: params }).body)

    response["items"].each do |result|
      @results.push({
        title: result["title"],
        link: result["link"],
        snippet: result["snippet"]
      })
    end
  end

  def bing(query)
    params = { customconfig: ENV["bing_customconfig"], q: @query }
    headers = { "Ocp-Apim-Subscription-Key": ENV["bing_key"] }

    response = JSON.parse(HTTParty.get(ENV["bing_url"], {query: params, headers: headers }).body)

    response["webPages"]["value"].each do |result|
      @results.push({
        title: result["name"],
        link: result["url"],
        snippet: result["snippet"]
      })
    end
  end
end
