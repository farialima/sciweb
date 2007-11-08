class InterfaceController < ApplicationController
  
  layout "interface"
  before_filter :authorize, :except => [ :login, :add_user, :logout ]

  def index
    @user = User.find(session[:user_id])
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
  
  ### metodos para adicionar usuario, login e logout
  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:user][:username], params[:user][:password])
      if user
        session[:user_id] = user.id
        redirect_to :action => "index"
      else
        flash[:notice] = "Nome de usuário/senha inválidos"
      end
    else
      @user = User.new
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logout efetuado com sucesso"
    redirect_to(:action => "login" )
  end
  
  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = "Usuário #{@user.username} criado. Você já pode fazer o login."
      @user = User.new
      redirect_to :action => "login"
    end
    
  end
  ### FIM
  
end
