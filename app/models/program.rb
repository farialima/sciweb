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
end
