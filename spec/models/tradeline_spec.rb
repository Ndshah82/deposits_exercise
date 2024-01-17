require 'rails_helper'

RSpec.describe Tradeline, type: :model do
    subject { FactoryBot.create(:tradeline) }

    it { should validate_uniqueness_of(:name) }
end