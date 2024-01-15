class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true
      t.string :token, null: false, index: :unique
      t.integer :operation, null: false
      t.integer :value, null: false
      t.string :title, null: false
      t.text :comment
      t.date :date, null: false

      t.timestamps
    end
  end
end
