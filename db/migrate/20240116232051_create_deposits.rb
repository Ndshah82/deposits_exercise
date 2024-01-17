class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.belongs_to :tradeline
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
