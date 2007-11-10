class CreateLibs < ActiveRecord::Migration
  def self.up
    create_table :libs do |t|
      t.column :user_id, :integer, :null => false
      t.column :nome, :string, :limit => 20
      t.column :descricao, :string, :limit => 50
      t.column :codigo, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :libs
  end
end
