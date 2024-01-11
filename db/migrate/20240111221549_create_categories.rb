class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :token, null: false, index: :unique
      t.string :name
      t.datetime :discarded_at
      t.belongs_to(:users, foreign_key: true)

      t.timestamps
    end
  end
end
