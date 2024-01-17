require 'roar/decorator'
require 'roar/json'

class DepositRepresenter < Roar::Decorator
  include Roar::JSON

  property :amount
  property :created_at
end