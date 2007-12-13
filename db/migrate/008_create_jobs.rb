class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :user_id, :integer
      t.column :program_id, :integer
      t.column :id_node, :integer
      t.column :pronto, :boolean, :default => false
      t.column :grafico, :string, :limit => 200
      t.column :parametros, :text
      t.column :retorno, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :jobs
  end
end
