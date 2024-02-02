class CreateBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :billings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :due_date, null: false
      t.integer :cycles, null: false

      t.timestamps
    end
  end
end
