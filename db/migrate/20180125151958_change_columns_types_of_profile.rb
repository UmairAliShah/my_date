class ChangeColumnsTypesOfProfile < ActiveRecord::Migration[5.1]
  def up
      change_column :profiles, :latitude, :decimal, :precision => 15, :scale => 13
      change_column :profiles, :longitude, :decimal, :precision => 15, :scale => 13
    end

    def down
      change_column :profiles, :latitude, :float
      change_column :profiles, :longitude, :float
    end
end
