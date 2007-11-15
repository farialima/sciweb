class AddColunaRetorno < ActiveRecord::Migration
  def self.up
    add_column :programs, :tipo_retorno, :string, :limit => 20
  end

  def self.down
    remove_column :programs, :tipo_retorno
  end
end
