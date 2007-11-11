module InterfaceHelper
  def my_programs
    Program.find( :all, :conditions => ["user_id = ?", session[:user_id] ], :order => "updated_at DESC" )
  end
  
  def my_libs
    Lib.find( :all, :conditions => ["user_id = ?", session[:user_id] ], :order => "updated_at DESC" )
  end
  
  def public_programs
    Program.find( :all, :conditions => ["user_id != ? and publico = true", session[:user_id] ], :order => "updated_at DESC" )
  end
  
  def public_libs
    Lib.find( :all, :conditions => ["user_id != ? and publico = true", session[:user_id] ], :order => "updated_at DESC" )
  end
end
