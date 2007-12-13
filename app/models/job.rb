# == Schema Information
# Schema version: 8
#
# Table name: jobs
#
#  id         :integer         not null, primary key
#  user_id    :integer         
#  program_id :integer         
#  id_node    :integer         
#  pronto     :boolean         
#  grafico    :string(200)     
#  parametros :text            
#  retorno    :text            
#  created_at :datetime        
#  updated_at :datetime        
#

require "fileutils"

class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  after_destroy { |record| FileUtils.remove_file(`pwd`.chomp.gsub(/\/public/, '') << "/public/images/graficos/#{record.user.username}/#{record.grafico}") }
end
