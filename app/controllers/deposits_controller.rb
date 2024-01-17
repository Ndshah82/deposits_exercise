class DepositsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def index
        render json: DepositRepresenter.for_collection.new(Tradeline.find(params[:tradeline_id]).deposits).to_json
    end

    def show
        render json: DepositRepresenter.new(Tradeline.find(params[:tradeline_id]).deposits.find(params[:id])).to_json
    end

    def create
        tradeline = Tradeline.find(params[:tradeline_id])
        deposit = tradeline.deposits.build(amount: params[:amount])

        if deposit.valid?
            deposit.save
            render json: DepositRepresenter.new(deposit).to_json
        else
            render json: deposit.errors, status: 400
        end
    end

    private

    def not_found
        render json: 'not_found', status: :not_found
    end
end
