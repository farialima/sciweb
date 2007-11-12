class ScilabInterface
  def initialize(program, grafico)
    @program = program
    @grafico = grafico
  end
  def exec
    comando = ""
    comando << "export DISPLAY=:3\n"
    comando << "scilab -nw << EOF\n"
    comando << "scf(0);\n"
    if @program.libs.count > 0
      @program.libs.each { |i| comando << i.codigo.gsub(/\r/, "") + "\n" }
    end
    comando << @program.codigo.gsub(/\r/, "") + "\n"
    comando << "xs2gif(0,'#{@grafico}');\n"
    comando << "exit;\n"
    comando << "EOF\n"
    `#{comando}`
  end
end
