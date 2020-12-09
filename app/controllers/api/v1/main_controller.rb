class Api::V1::MainController < ApplicationController
  def search
    engine = search_params[:engine].split(/\s*,\s*/)
    query = search_params[:text]
    search = SearchService.new(engine: engine, query: query).perform_search
    render json: {status: 'Success', message: 'search results',
      results: search.size, data: search }, status: :ok
  end

  private
  def search_params
    params.require(:search).require(:engine)
    params.require(:search).require(:text)
    params.require(:search).permit(:engine, :text)
  end
end
