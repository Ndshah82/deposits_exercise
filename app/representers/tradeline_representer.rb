require 'representable/json'

class TradelineRepresenter < Representable::Decorator
  include Representable::JSON

  property :name
  property :amount

  collection :deposits, representer: DepositRepresenter, class: Deposit
end