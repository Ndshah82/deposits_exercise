require 'rails_helper'

RSpec.describe "Tradelines", type: :request do
    describe 'GET /index' do
        it 'returns no results when there are none' do
            get '/tradelines'

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to be_empty
        end

        it 'returns results when there are some' do
            FactoryBot.create(:tradeline, name: '1000', amount: 1000)
            FactoryBot.create(:tradeline, name: '2000', amount: 2000)

            get '/tradelines'

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to include(
                {
                    'name' => '1000',
                    'amount' => '1000.0'
                },
                {
                    'name' => '2000',
                    'amount' => '2000.0'
                }
            )
        end
    end

    describe 'GET /show' do
        it 'returns not_found when not found' do
            get '/tradelines/-1'

            expect(response).to have_http_status(:not_found)
        end

        it 'returns success when found' do
            tradeline = FactoryBot.create(:tradeline, name: '1000', amount: 1000)

            get "/tradelines/#{tradeline.id}"

            expect(response).to have_http_status(:ok)

            expect(JSON.parse(response.body)).to include('name' => '1000', 'amount' => '1000.0')
        end
    end
end