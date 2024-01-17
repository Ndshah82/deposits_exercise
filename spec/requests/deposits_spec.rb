require 'rails_helper'

RSpec.describe "Deposits", type: :request do
  describe "POST /create" do
    it 'returns not found for missing tradeline' do
      post "/tradelines/-1/deposits", params: { tradeline_id: -1, amount: 100 }

      expect(response).to have_http_status(:not_found)
    end

    it 'returns validation error for amount less than zero' do
      tradeline = FactoryBot.create(:tradeline)
      
      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: -1 }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('{"amount":["must be greater than zero"]}')
    end

    it 'returns validation error for amount of zero' do
      tradeline = FactoryBot.create(:tradeline)

      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 0 }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('{"amount":["must be greater than zero"]}')
    end

    it 'returns validation error for amount over balance' do
      tradeline = FactoryBot.create(:tradeline)

      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 2000 }
      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 2000 }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('{"amount":["greater than tradeline balance"]}')
    end

    it 'renders success for valid entry' do
      tradeline = FactoryBot.create(:tradeline)

      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 1000 }
      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 1000 }

      expect(response).to have_http_status(:ok )

      body = JSON.parse(response.body)
      expect(body['amount'].to_d).to eq(1000)
    end
  end

  describe "GET /index" do
    it 'returns a not_found when tradeline not found' do
      get "/tradelines/-1/deposits"

      expect(response).to have_http_status(:not_found)
    end

    it 'returns an empty set when there are none' do
      tradeline = FactoryBot.create(:tradeline)

      get "/tradelines/#{tradeline.id}/deposits"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_empty
    end

    it 'returns a list of deposits when there are some' do
      tradeline = FactoryBot.create(:tradeline)

      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 1000 }
      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 1000 }

      get "/tradelines/#{tradeline.id}/deposits"

      expect(response).to have_http_status(:ok )

      body = JSON.parse(response.body)
      expect(body.map { |h| h['amount'] }.map(&:to_d)).to eq([1000, 1000])
    end
  end

  describe 'GET /show' do
    it 'returns a not_found when tradeline not found' do
      get "/tradelines/-1/deposits/1"

      expect(response).to have_http_status(:not_found)
    end

    it 'returns a not_found when deposit not found' do
      tradeline = FactoryBot.create(:tradeline)

      get "/tradelines/#{tradeline.id}/deposits/-1"

      expect(response).to have_http_status(:not_found)
    end

    it 'returns the deposit when successfully found' do
      tradeline = FactoryBot.create(:tradeline)

      post "/tradelines/#{tradeline.id}/deposits", params: { tradeline_id: tradeline.id, amount: 1000 }

      get "/tradelines/#{tradeline.id}/deposits/#{tradeline.deposits.first.id}"

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body['amount'].to_d).to eq(1000)
    end
  end
end
