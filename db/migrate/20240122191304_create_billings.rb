class CreateBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :billings do |t|
      t.string :description, null: false
      t.integer :due_date, null: false
      t.integer :cycles, null: false
      t.references :last_entry, null: false, foreign_key: { to_table: :entries }

      t.timestamps
    end
  end
end
