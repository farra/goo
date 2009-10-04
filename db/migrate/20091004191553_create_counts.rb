class CreateCounts < ActiveRecord::Migration
  def self.up
    create_table :counts do |t|
      t.integer :total
      t.integer :interval
      t.timestamps
    end
  end

  def self.down
    drop_table :counts
  end
end
