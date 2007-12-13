# == Schema Information
# Schema version: 8
#
# Table name: libs
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  nome       :string(40)      
#  descricao  :text            
#  codigo     :text            
#  publico    :boolean         default(TRUE)
#  created_at :datetime        
#  updated_at :datetime        
#

class Lib < ActiveRecord::Base
  validates_presence_of :nome
  validates_presence_of :descricao
  validates_presence_of :codigo
  
  belongs_to :user
  has_and_belongs_to_many :programs
end
