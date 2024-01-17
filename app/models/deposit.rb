class Deposit < ApplicationRecord
    belongs_to :tradeline

    validate :amount_greater_than_zero
    validate :amount_less_than_tradeline_balance

    private

    def amount_greater_than_zero
        unless amount > 0
            errors.add(:amount, "must be greater than zero")
        end
    end

    def amount_less_than_tradeline_balance
        unless tradeline_balance > 0
            errors.add(:amount, "greater than tradeline balance")
        end
    end

    def tradeline_balance
        tradeline.amount - tradeline.deposits.map(&:amount).sum
    end
end
