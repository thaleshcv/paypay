class AddBillingIdToEntries < ActiveRecord::Migration[7.1]
  def change
    change_table :entries do |t|
      t.belongs_to :billing, null: true, foreign_key: true
    end
  end
end
