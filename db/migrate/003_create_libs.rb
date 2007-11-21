class CreateLibs < ActiveRecord::Migration
  def self.up
    create_table :libs do |t|
      t.column :user_id, :integer, :null => false
      t.column :nome, :string, :limit => 40
      t.column :descricao, :text
      t.column :codigo, :text
      t.column :publico, :boolean, :default => true
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :libs
  end
end
