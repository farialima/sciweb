class Lib < ActiveRecord::Base
  validates_presence_of :nome
  validates_presence_of :descricao
  validates_presence_of :codigo
  
  belongs_to :user
  has_and_belongs_to_many :programs
end
