class ScilabInterface
  def initialize(program, grafico)
    @program = program
    @grafico = grafico
  end
  def exec
    comando = ""
    comando << "export DISPLAY=:3\n"
    comando << "scilab -nw << EOF\n"
    comando << "scf(0);\n" if @program.tipo_retorno == "grafico"
    if @program.libs.count > 0
      @program.libs.each { |i| comando << i.codigo.gsub(/\r/, "") + "\n" }
    end
    comando << @program.codigo.gsub(/\r/, "") + "\n"
    comando << "xs2gif(0,'#{@grafico}');\n" if @program.tipo_retorno == "grafico"
    comando << "exit;\n"
    comando << "EOF\n"
    `#{comando}`
  end
  
  def ScilabInterface.extract_values(string_retorno)
    string_retorno.split("-->").grep(/^\s*\w+\s+=$/).join("<br/>").gsub(/\s/, "&nbsp;").gsub(/ans\s*/, "").gsub(/=/, "")
  end
end
