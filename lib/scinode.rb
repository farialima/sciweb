#!/usr/bin/ruby
require 'drb'

class SciNode
  attr_accessor :codigo, :retorno_grafico, :grafico, :executando_job
  def initialize
    @executando_job = false
  end
  def cpu
    `uptime | cut -d' ' -f 12`.gsub!(/,/,'').chomp
  end
  def exec
    comando = ""
    comando << "export DISPLAY=:0\n"
    comando << "scilab -nw << EOF\n"
    comando << "scf(0);\n" if retorno_grafico
    comando << @codigo.gsub(/\r/, "") + "\n"
    comando << "xs2gif(0,'#{@grafico}');\n" if retorno_grafico
    comando << "exit;\n"
    comando << "EOF\n"
    @executando_job = true
    retorno = `#{comando}`
    @executando_job = false
    retorno
  end
  def get_image
    f = File.open(@grafico, "rb")
    f.read
  end
end

node = SciNode.new
DRb.start_service('druby://:9000', node)
DRb.thread.join
