class CreateInterests < ActiveRecord::Migration[5.1]
  def change
    create_table :interests do |t|
      t.boolean :romance
      t.boolean :parties
      t.boolean :selfies
      t.boolean :fashion
      t.boolean :movies
      t.boolean :music
      t.boolean :sports
      t.boolean :travelling
      t.boolean :culture
      t.boolean :news
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
