class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string, :limit => 20
      t.column :hashed_password, :string
      t.column :salt, :string
      t.column :nomecompleto, :string, :limit => 50
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :users
  end
end
