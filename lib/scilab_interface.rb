class ScilabInterface
  def initialize(codigo, grafico)
    @codigo = codigo
    @grafico = grafico
  end
  def exec
    comando = ""
    comando << "export DISPLAY=:3\n"
    comando << "scilab -nw << EOF\n"
    comando << "scf(0)\n"
    comando << @codigo+"\n"
    comando << "xs2gif(0,'#{@grafico}')\n"
    comando << "exit\n"
    comando << "EOF\n"
    `#{comando}`.chomp
  end
end
