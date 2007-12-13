class DeletarColunaDeRetorno < ActiveRecord::Migration
  def self.up
    remove_column(:programs, :tipo_retorno)
  end

  def self.down
  end
end
