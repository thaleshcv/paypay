class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :category, null: true, foreign_key: true
      t.string :token, null: false, index: :unique
      t.integer :value, null: false
      t.string :description, null: false
      t.text :comment
      t.date :date, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
