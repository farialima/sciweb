module Extenso 
  @@unidade = {
    0 => "zero",  
    1 => "um",  
    2 => "dois",  
    3 => "três",  
    4 => "quatro",  
    5 => "cinco",  
    6 => "seis",  
    7 => "sete",  
    8 => "oito",  
    9 => "nove" 
  }
  @@dezena = {
    10 => "dez",  
    11 => "onze",  
    12 => "doze",  
    13 => "treze",  
    14 => "quatorze",  
    15 => "quinze",  
    16 => "dezesseis",  
    17 => "dezessete",  
    18 => "dezoito",  
    19 => "dezenove",  
    20 => "vinte",  
    30 => "trinta",  
    40 => "quarenta",  
    50 => "cinquenta",  
    60 => "sessenta",  
    70 => "setenta",  
    80 => "oitenta",  
    90 => "noventa"  }
  @@centena = {100 => "cento",  
    200 => "duzentos",  
    300 => "trezentos",  
    400 => "quatrocentos",  
    500 => "quinhentos",  
    600 => "seiscentos",  
    700 => "setecentos",  
    800 => "oitocentos",  
    900 => "novecentos"  }
  
  # Escreve o numero por extenso.
  # 
  # Exemplo:
  #  1.por_extenso ==> 'um'
  #  100.por_extenso ==> 'cem'
  #  158.por_extenso ==> 'cento e cinquenta e oito'
  def por_extenso
    Extenso.por_extenso(self)
  end

  # DEPRECATION WARNING: use por_extenso, pois este sera removido no proximo release.
  def to_extenso
    warn('DEPRECATION WARNING: use por_extenso, pois este sera removido no proximo release.')
    self.por_extenso
  end
  
  # Escreve o numero por extenso.
  # 
  # Exemplo:
  #  Extenso.por_extenso(1) ==> "um"
  #  Extenso.por_extenso(100) ==> "cem"
  #  Extenso.por_extenso(158) ==> "cento e cinquenta e oito"  
  def Extenso.por_extenso(numero)
    n=numero.to_i.abs
    return case n
    when 0..9: @@unidade[n].to_s 
    when 10..19: @@dezena[n].to_s
    when 20..99:
      v=n % 10
      if  v== 0
        @@dezena[n].to_s
      else
        "#{@@dezena[n-v]} e #{por_extenso(v)}"
      end
    when 100
      "cem"     
    when 101..999
      v=n % 100
      if  v== 0
        @@centena[n].to_s
      else
        "#{@@centena[n-v]} e #{por_extenso(v)}"
      end
    when 1000..999999  
      m,c=n/1000,n%1000
      %(#{por_extenso(m)} mil#{c > 0 ? " e #{por_extenso(c)}":''})
    when 1_000_000..999_999_999
      mi,m=n/1_000_000,n%1_000_000
      %(#{por_extenso(mi)} milh#{mi > 1 ? 'ões':'ão'}#{m > 0 ? " e #{por_extenso(m)}" : ''})
    when 1_000_000_000..999_999_999_999
      bi,mi=n/1_000_000_000,n%1_000_000_000
      %(#{por_extenso(bi)} bilh#{bi > 1 ? 'ões':'ão'}#{mi > 0 ? " e #{por_extenso(mi)}" : ''})
    when 1_000_000_000_000..999_999_999_999_999
      tri,bi=n/1_000_000_000_000,n%1_000_000_000_000
      %(#{por_extenso(tri)} trilh#{tri > 1 ? 'ões':'ão'}#{bi > 0 ? " e #{por_extenso(bi)}" : ''})
    else
      raise "Valor excede o permitido: #{n}"
    end
  end
end

module ExtensoReal
  include Extenso
 
  # Escreve por extenso em reais.
  # 
  # Exemplo:
  #  1.por_extenso_em_reais ==> 'um real'
  #  (100.58).por_extenso_em_reais ==> 'cem reais e cinquenta e oito centavos'
  def por_extenso_em_reais
    ExtensoReal.por_extenso_em_reais(self.to_s)
  end

  # DEPRECATION WARNING: use por_extenso_em_reais, pois este sera removido no proximo release.
  def to_extenso_real
    warn('DEPRECATION WARNING: use por_extenso_em_reais, pois este sera removido no proximo release.')
    self.por_extenso_em_reais
  end
 
  # Escreve o numero por extenso em reais.
  # 
  # Exemplo:
  #  Extenso.por_extenso_em_reais(1) ==> "um real"
  #  Extenso.por_extenso_em_reais(100) ==> "cem reais"
  #  Extenso.por_extenso_em_reais(100.58) ==> "cem reais e cinquenta e oito centavos"  
  def ExtensoReal.por_extenso_em_reais(valor)
    return 'grátis' if valor == 0
    case valor
    when Integer 
      extenso = Extenso.por_extenso(valor)
      if extenso =~ /^(.*)(ão$|ões$)/
        complemento = 'de '
      else
        complemento = ''
      end
      %(#{extenso} #{valor <= 1 ? 'real': "#{complemento}reais"})
    when Float
      real,cents=("%.2f" % valor).split(/\./).map{ |m| m.to_i}
      valor_cents=Extenso.por_extenso(cents%100)
       
      valor_cents+= case cents.to_i%100
      when 0: ""
      when 1: " centavo"
      when 2..99: " centavos"
      end 
       
      if real.to_i > 0
        "#{ExtensoReal.por_extenso_em_reais(real.to_i)}#{cents > 0 ? ' e ' + valor_cents : ''}"
      else
        "#{valor_cents}"
      end
    else
      ExtensoReal.por_extenso_em_reais(valor.to_s.strip.gsub(/[^\d]/,'.').to_f)
    end
  end
end