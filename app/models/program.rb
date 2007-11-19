class Program < ActiveRecord::Base
  
  TIPOS_RETORNO = [
    #Exibido  Armazenado
    ["Gráfico",         "grafico"],
    ["Numérico",     "numerico"]
  ]
  
  validates_presence_of :nome, :descricao, :codigo, :parametros, :tipo_retorno
  validates_inclusion_of :tipo_retorno, :in => TIPOS_RETORNO.map { |disp, value| value }
  
  belongs_to :user
  has_and_belongs_to_many :libs
  
  def adiciona_parametros(parametros_adicionais)
    codigo_original = self.codigo
    self.codigo = ""
    parametros_adicionais.each do |key, value|
      if value.class != Array
        self.codigo << "#{key} = #{value};\n"  
      else
        self.codigo << "#{key} = zeros(#{value.length}, 1);\n"
        value.each_with_index { |item, index| codigo << "#{key}(#{index+1}) = #{item};\n" }
      end
    end
    self.codigo << codigo_original
  end
  
  def adiciona_libs
    codigo_original = self.codigo
    self.codigo = ""
    if self.libs.count > 0
      self.libs.each { |i| self.codigo << i.codigo.gsub(/\r/, "") + "\n" }
    end
    self.codigo << codigo_original
  end
end
