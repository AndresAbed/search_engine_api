require 'rails_helper'

RSpec.describe "Api::V1::Mains", type: :request do
  let(:spec_path) { "/api/v1/search" }

  describe "POST #search" do

    before :each do
      google_response_body = File.open("./spec/fixtures/google_response.json")
      stub_request(:get, ENV["google_url"]).
      to_return(status: 200, body: google_response_body)

      bing_response_body = File.open("./spec/fixtures/bing_response.json")
      stub_request(:get, ENV["bing_url"]).
      to_return(status: 200, body: bing_response_body)
    end

    it "params are missing" do
      expect{ post(spec_path, {}) }.to raise_error ActionController::ParameterMissing
    end

    it "params are present" do
      post spec_path, params: {search: {engine: "google", text: "search"}}
      expect(response).to be_successful
    end

    it "a param is not permited" do
      expect{ post(spec_path, params: {search: {engine: "google",
        text: "search", date: "today"}})
      }.to raise_error ActionController::UnpermittedParameters
    end

    it "performs a google search" do
      post spec_path, params: {search: {engine: "google", text: "search"}}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["status"]).to eq("Success")
      expect(parsed_response["results"]).to eq(10)
    end

    it "performs a bing search" do
      post spec_path, params: {search: {engine: "bing", text: "search"}}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["status"]).to eq("Success")
      expect(parsed_response["results"]).to eq(10)
    end

    it "performs a multi search" do
      post spec_path, params: {search: {engine: "google, bing", text: "search"}}
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["status"]).to eq("Success")
      expect(parsed_response["results"]).to eq(20)
    end
  end
end
