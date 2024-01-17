class DepositsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def index
        render json: Tradeline.find(params[:tradeline_id]).deposits
    end

    def show
        render json: Tradeline.find(params[:tradeline_id]).deposits.find(params[:id])
    end

    def create
        tradeline = Tradeline.find(params[:tradeline_id])
        deposit = Deposit.new(tradeline_id: tradeline.id, amount: params[:amount])

        if deposit.valid?
            deposit.save
            render json: deposit
        else
            render json: deposit.errors, status: 400
        end
    end

    private

    def not_found
        render json: 'not_found', status: :not_found
    end
end
