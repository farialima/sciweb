#!/usr/bin/ruby
require 'drb'

DRb.start_service()
node = DRbObject.new(nil, 'druby://192.168.1.102:9000')
puts "CPU: " + node.cpu
node.codigo = "x = 0:1:10;\ny = x^2;\nplot(x,y);"
node.tipo_retorno = "grafico"
node.grafico = "drb.gif"
puts "exec: " + node.exec
grafico = File.open("teste.gif","wb")
grafico.write node.get_image
grafico.close
