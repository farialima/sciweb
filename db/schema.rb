# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 6) do

  create_table "libs", :force => true do |t|
    t.column "user_id",    :integer,                                  :null => false
    t.column "nome",       :string,   :limit => 40
    t.column "descricao",  :text
    t.column "codigo",     :text
    t.column "publico",    :boolean,                :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "libs_programs", :id => false, :force => true do |t|
    t.column "lib_id",     :integer
    t.column "program_id", :integer
  end

  create_table "nodes", :force => true do |t|
    t.column "ip", :string
  end

  create_table "programs", :force => true do |t|
    t.column "user_id",      :integer,                                  :null => false
    t.column "nome",         :string,   :limit => 40
    t.column "descricao",    :text
    t.column "codigo",       :text
    t.column "parametros",   :text
    t.column "publico",      :boolean,                :default => true
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "tipo_retorno", :string,   :limit => 20
  end

  create_table "users", :force => true do |t|
    t.column "username",        :string,   :limit => 20
    t.column "hashed_password", :string
    t.column "salt",            :string
    t.column "nomecompleto",    :string,   :limit => 50
    t.column "created_at",      :datetime
    t.column "updated_at",      :datetime
  end

end
