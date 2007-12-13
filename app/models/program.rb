# == Schema Information
# Schema version: 6
#
# Table name: programs
#
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  nome         :string(40)      
#  descricao    :text            
#  codigo       :text            
#  parametros   :text            
#  publico      :boolean         default(TRUE)
#  created_at   :datetime        
#  updated_at   :datetime        
#  tipo_retorno :string(20)      
#

class Program < ActiveRecord::Base
  
  validates_presence_of :nome, :descricao, :codigo, :parametros
  
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
        self.codigo << "#{key} = zeros(#{value.length});\n"
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
  
  def tem_retorno_numerico?(retorno_do_scilab)
    retorno_do_scilab.split("-->").grep(/^\s*\w+\s+=/).length > 0
  end
  
  def tem_retorno_grafico?
    resultado_da_busca = false
    IO.foreach(`pwd`.chomp.gsub(/\public/, "") + "/public/scilab_graphic_functions.txt") { |funcao| if self.codigo.include?(funcao.chomp) then resultado_da_busca = true; break end }
    resultado_da_busca
  end
end
