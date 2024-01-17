require 'rails_helper'

RSpec.describe Deposit, type: :model do
    let(:tradeline) { FactoryBot.create(:tradeline) }
    
    describe '#amount_greater_than_zero' do
        let(:subject) { FactoryBot.build(:deposit, tradeline_id: tradeline.id) }    

        it 'is not valid for amount of zero' do
            subject.amount = 0

            expect(subject.valid?).to be false
        end

        it 'is not valid for amount less than zero' do
            subject.amount = -1

            expect(subject.valid?).to be false
        end

        it 'is valid for amount greater than zero' do
            subject.amount = 1

            expect(subject.valid?).to be true
        end
    end

    describe '#amount_less_than_tradeline_balance' do
        let!(:deposit) { FactoryBot.create(:deposit, tradeline_id: tradeline.id, amount: 2000) }

        it 'is not valid for amount greater than balance' do
            subject = tradeline.deposits.create(amount: 2000)
            expect(subject.valid?).to be false
        end

        it 'is valid for amount less than balance' do
            subject = tradeline.deposits.create(amount: 1000)
            expect(subject.valid?).to be true
        end
    end
end