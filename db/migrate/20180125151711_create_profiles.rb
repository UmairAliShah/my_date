class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :state
      t.string :city
      t.string :country
      t.string :code
      t.string :provider
      t.string :provider_id
      t.string :img_url
      t.string :about_me
      t.string :gender
      t.string :interested_in
      t.string :address
      t.date :date_of_birth
      t.boolean :is_online
      t.float :latitude
      t.float :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
