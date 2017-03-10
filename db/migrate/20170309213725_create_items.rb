class CreateItems < ActiveRecord::Migration

  def self.up
    create_table :items do |t|
      t.string :creator, null: false, index: true
      t.string :name, null: false
      t.datetime :removed_at, index: true

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end

end
