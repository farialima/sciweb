# == Schema Information
# Schema version: 6
#
# Table name: nodes
#
#  id :integer         not null, primary key
#  ip :string(255)     
#

class Node < ActiveRecord::Base
  validates_presence_of :ip
  validates_uniqueness_of :ip
end
