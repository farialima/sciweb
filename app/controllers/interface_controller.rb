class InterfaceController < ApplicationController
  
  require "yaml"
  require "ping"
  require "drb"
  
  layout "interface"
  before_filter :authorize, :except => [ :login, :add_user, :logout ]

  def index
    @user = User.find(session[:user_id])
  end
  
  def add_program
    @program, @libs = Program.new, Lib.new
  end
  
  def save_program
    @program = Program.new(params[:program])
    @program.user_id = session[:user_id]
    if !(params[:lib].nil?)
      if params[:lib].length  > 0
        params[:lib].each { |i| @program.libs << Lib.find(i) }
      end
    end
    if request.post? and @program.save
      flash[:notice] = "Programa gravado com sucesso."
      redirect_to :action => "index"
    else
      flash[:notice] = "Problemas ao gravar o programa... Tente novamente."
      render :action => "add_program"
    end
  end
  
  def exec_program
    @program = Program.find(params[:id])
    @parametros = YAML.load( @program.parametros.gsub(/\r/,"\n") )
  end
  
  def process_program
    @program = Program.find(params[:id])
    @user = User.find(session[:user_id])
    @program.adiciona_parametros params[:parametros]
    @identificador = @program.nome + rand(1000).to_s
    nome_arquivo = `pwd`.chomp.gsub(/\/public/, '') << "/public/images/graficos/#{@user.username}/#{@identificador}.gif"
    @job = Job.new(:user_id => @user.id, :program_id => @program.id, :parametros =>params[:parametros])
    retorno_grafico = @program.tem_retorno_grafico?
    node_ready = get_node_ready(Node.find(:all))
    if node_ready.nil?
      @job.id_node = 0
      @job.save
      spawn do
        @job.retorno = ScilabInterface.new(@program, nome_arquivo, retorno_grafico).exec
        @job.grafico = "#{@identificador}.gif"
        @job.pronto = true
        @job.save
      end
    else
      remote_node = DRbObject.new(nil, "druby://#{node_ready.ip}:9000")
      @job.id_node = node_ready.id
      @job.save
      @program.adiciona_libs
      spawn do
        remote_node.codigo = @program.codigo
        remote_node.retorno_grafico = retorno_grafico
        remote_node.grafico = @identificador + ".gif"
        @job.retorno = remote_node.exec
        @job.grafico = "#{@identificador}.gif"
        grafico = File.open( "public/images/graficos/#{@user.username}/#{@identificador}.gif","wb")
        grafico.write remote_node.get_image
        grafico.close
        @job.pronto = true;
        @job.save
      end
    end
  end
  
  def program_results
    @job = Job.find(params[:id])
  end
  
  def edit_program
    @program = Program.find(params[:id])
    redirect_to :action => "index" if session[:user_id] != @program.user.id
  end
  
  def update_program
    @program = Program.find(params[:id])
    @program.libs.delete_all
    if !(params[:lib].nil?)
      if params[:lib].length  > 0
        params[:lib].each { |i| @program.libs << Lib.find(i) }
      end
    end
    # a linha abaixo eh para protecao. precisa ser reformulada
    #redirect_to :action => "index"; return if session[:user_id] != @program.user.id
    if @program.update_attributes(params[:program])
      flash[:notice] = 'O programa foi atualizado com sucesso.'
      redirect_to :action => "exec_program", :id => @program.id
    else
      render :action => 'edit_program'
    end
  end
  
  def destroy_program
    if session[:user_id] != Program.find(params[:id]).user.id then redirect_to :action => "index"; return end
    Program.find(params[:id]).destroy
    flash[:notice] = "O programa foi removido com sucesso."
    redirect_to :action => "index" 
  end
  
  def get_job_status
    @job = Job.find(params[:job_id])
    render :partial => "get_job_status", :locals => { :job => @job } 
  end
  
  def destroy_job
    if session[:user_id] != Job.find(params[:id]).user.id then redirect_to :action => "index"; return end
    Job.find(params[:id]).destroy
    flash[:notice] = "O Job foi removido com sucesso."
    redirect_to :action => "index" 
  end
  
  def add_lib
    @lib = Lib.new
  end
  
  def save_lib
    @lib = Lib.new(params[:lib])
    @lib.user_id = session[:user_id]
    if request.post? and @lib.save
      flash[:notice] = "Biblioteca gravada com sucesso."
      redirect_to :action => "index"
    else
      flash[:notice] = "Problemas ao gravar a biblioteca... Tente novamente."
      render :action => "add_lib"
    end
  end
  
  def view_lib
    @lib = Lib.find(params[:id])
  end
  
  def edit_lib
    @lib = Lib.find(params[:id])
    redirect_to :action => "index" if session[:user_id] != @lib.user.id
  end
  
  def update_lib
    @lib = Lib.find(params[:id])
    if @lib.update_attributes(params[:lib])
      flash[:notice] = 'A biblioteca foi atualizada com sucesso.'
      redirect_to :action => "index"
    else
      render :action => 'edit_lib'
    end
  end
  
  def destroy_lib
    if session[:user_id] != Lib.find(params[:id]).user.id then redirect_to :action => "index"; return end
    Lib.find(params[:id]).destroy
    flash[:notice] = "A biblioteca foi removida com sucesso."
    redirect_to :action => "index" 
  end
  
  # Actions referentes ao cluster
  def manage_cluster
    @nodes = Node.find(:all)
  end
  
  def add_node
    @node = Node.new
  end
  
  def save_node
    @node = Node.new(params[:node])
    if request.post? and @node.save
      flash[:notice] = "Host adicionado com sucesso ao cluster."
      redirect_to :action => "index"
    else
      flash[:notice] = "Problemas ao adicionar o nó... Tente novamente."
      render :action => "add_node"
    end
  end
  
  def destroy_node
    Node.find(params[:id]).destroy
    flash[:notice] = "O nó foi removido com sucesso."
    redirect_to :action => "manage_cluster" 
  end
  
  def get_node_status
    @node = Node.find(params[:node_id])
    @status = check_node_status(@node)
    render :partial => "get_node_status"
  end
  
  def check_node_status(node)
    if Ping.pingecho(node.ip)
      DRb.start_service()
      node = DRbObject.new(nil, "druby://#{node.ip}:9000")
      begin
        node.cpu
        status = "ready"
      rescue Exception
        status = "notready"
      end
    else
      status = "offline"
    end
    status
  end
  
  # metodo para retornar o Node que esta alcancavel, pronto e com a menor carga no processador, selecionando dentre um array de nodes
  def get_node_ready(nodes)
    ready_nodes = nodes.select { |node| check_node_status(node) == "ready" }
    idle_nodes = []
    ready_nodes.each { |node| idle_nodes << node if !(DRbObject.new(nil, "druby://#{node.ip}:9000").executando_job) }
    idle_nodes.min{|a,b| DRbObject.new(nil, "druby://#{a.ip}:9000").cpu <=>  DRbObject.new(nil, "druby://#{b.ip}:9000").cpu }
  end
  # FIM - Actions referentes ao cluster
  
  def processa
    @codigo = params[:codigo]
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
        render :action => "login"
        return
      end
    else
      @user = User.new
      render :action => "login"
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logout efetuado com sucesso"
    redirect_to :action => "login"
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
