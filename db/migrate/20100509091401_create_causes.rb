class CreateCauses < ActiveRecord::Migration
  def self.up
    create_table :causes do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :metro_area_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :causes
  end
end
