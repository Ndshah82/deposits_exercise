class TradelinesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    render json: TradelineRepresenter.for_collection.new(Tradeline.all).to_json(exclude: [:deposits])
  end

  def show
    render json: TradelineRepresenter.new(Tradeline.find(params[:id])).to_json(exclude: [:deposits])
  end

  private

  def not_found
    render json: 'not_found', status: :not_found
  end
end
