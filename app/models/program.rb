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
      if value.class != Array and value.class != HashWithIndifferentAccess
        self.codigo << "#{key} = #{value};\n"  
      end
      if value.class == Array
        self.codigo << "#{key} = zeros(#{value.length}, 1);\n"
        value.each_with_index { |item, index| self.codigo << "#{key}(#{index+1}) = #{item};\n" }
      end
      if value.class == HashWithIndifferentAccess
        self.codigo << "#{key} = zeros(#{value.keys.length}, #{value[value.keys.first].length});\n"
        value.each do |inner_key, inner_value|
          inner_value.each_with_index do |inner_item, inner_index|
            self.codigo << "#{key}(#{inner_key.to_i + 1},#{(inner_index.to_i + 1).to_s}) = #{inner_item};\n"
          end
        end
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
