class CreateJoinTable < ActiveRecord::Migration
  def self.up
    create_table :libs_programs, :id => false  do |t|
      t.column :lib_id, :integer
      t.column :program_id, :integer
    end
  end

  def self.down
    drop_table :libs_programs
  end
end
