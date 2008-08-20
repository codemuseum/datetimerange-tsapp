class CreatePageObjects < ActiveRecord::Migration
  def self.up
    create_table :page_objects do |t|
      t.string :urn
      t.datetime :starts_datetime
      t.datetime :ends_datetime
      t.string :time_zone

      t.timestamps
    end
    add_index :page_objects, :urn
    add_index :page_objects, :starts_datetime
    add_index :page_objects, :ends_datetime
  end

  def self.down
    drop_table :page_objects
  end
end
