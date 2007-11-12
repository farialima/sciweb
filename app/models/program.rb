class Program < ActiveRecord::Base
  validates_presence_of :nome
  validates_presence_of :descricao
  validates_presence_of :codigo
  validates_presence_of :parametros
  
  belongs_to :user
  has_and_belongs_to_many :libs
  
  def adiciona_parametros(parametros_adicionais)
    codigo_original = self.codigo
    self.codigo = ""
    parametros_adicionais.each { |key, value| self.codigo << "#{key} = #{value};\n" }
    self.codigo << codigo_original
  end
end
