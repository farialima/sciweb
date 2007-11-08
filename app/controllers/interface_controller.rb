class InterfaceController < ApplicationController

  def index
  end
  
  def processa
    @codigo = params[:textarea][:codigo]
    @identificador = rand(1000)
    @nome_arquivo = "public/images/#{@identificador}.gif"
    @comando = ScilabInterface.new(@codigo, @nome_arquivo).exec
    render :update do |page|
      #page.replace_html 'grafico', "<a style='display: none;' id='foto' href='images/arquivo.gif' rel='lightbox' title='Gráfico gerado pelo Scilab'>Gráfico gerado pelo Scilab</a>"
      page << "$('foto').href = 'images/#{@identificador}.gif';"
      page << "$('foto').onclick();"
    end
  end
  
  def muda_secao
    @secao = params[:secao]
    render :update do |page|
      #page.visual_effect(:toggle_appear, "home-left")
      page.delay(1) do
        page.replace_html "home-left", :partial => "#{@secao}"
        page.visual_effect(:toggle_appear, "home-left")
      end
    end
  end
end
