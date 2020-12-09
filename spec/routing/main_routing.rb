require "rails_helper"

RSpec.describe "Api::V1::Mains", type: :routing do
  describe 'routing' do
    it 'routes to #search' do
      expect(post: 'api/v1/search').to route_to('api/v1/main#search')
    end
  end
end
