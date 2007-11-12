class CreateJoinTable < ActiveRecord::Migration
  def self.up
    create_table :libs_programs do |t|
      t.column :lib_id, :integer
      t.column :program_id, :integer
    end
  end

  def self.down
  end
end
