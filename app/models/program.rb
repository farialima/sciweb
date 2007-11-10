class Program < ActiveRecord::Base
  validates_presence_of :nome
  validates_presence_of :descricao
  validates_presence_of :codigo
  validates_presence_of :parametros
end
