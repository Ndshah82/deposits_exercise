class Tradeline < ApplicationRecord
    has_many :deposits

    validates_uniqueness_of :name
end
