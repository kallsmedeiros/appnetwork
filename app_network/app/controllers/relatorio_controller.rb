class RelatorioController < ApplicationController
######################################################################################################################################################
# INICIO                                                               ALERTA
######################################################################################################################################################

  def gerar_excel_alerta
     xls = []
     xls << ['Alerta;']
     xls << ['ID;', 'Descricao;', 'Equipamento_id;', 'IP;', 'Hora;']
    @@alertas.each do |alerta|
     xls << ["#{alerta.id};", "#{alerta.descricao};", "#{alerta.equipamento_id};", "#{alerta.ip};", "#{alerta.created_at};"]
    end

    content = ''
    xls.each do |row|
#      row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/sim, " ").gsub(/ +/, " ") }
      row.map! {|col| col = col.to_s.gsub(/ +/, " ") }
      content << row.join("\t")
      content << "\n"
    end
    content

    `rm -rf "#{Rails.root}/public/excel/alerta_filtrar.xls`
    f = File.new("#{Rails.root}/public/excel/alerta_filtrar.xls", "w+")
    f << content
    f.close

    send_file "#{Rails.root}/public/excel/alerta_filtrar.xls"
  end

  def alerta_filtrar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def alerta_filtrar_do
    form                        = params[:form]
    colunas = ""
    valores = []
    conditions = []

    if not form[:id].eql? ""
      colunas << " AND " if not colunas.eql? ""
      colunas << "equipamento_id IN (?)"
      valores << form[:id].to_i
    end

    if not form[:data_inicio].eql? nil and not form[:data_fim].eql? nil
      data_inicio = Date.civil(*form[:data_inicio].sort.map(&:last).map(&:to_i))
      data_fim    = Date.civil(*form[:data_fim].sort.map(&:last).map(&:to_i))
      if not data_inicio > data_fim
        colunas << " AND " if not colunas.eql? ""
        colunas << "created_at >= (?) AND created_at <= (?)"
        valores << data_inicio.to_date
        valores << data_fim.to_date
      end
    end

    if form[:cpu].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%CPU%"
    end

    if form[:swap].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%SWAP%"
    end

    if form[:ram].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%RAM%"
    end

    if form[:disco].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%DISCO%"
    end

    if form[:banda].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%Banda%"
    end


    if form[:conexao].eql? "true"
      colunas << " AND " if not colunas.eql? ""
      colunas << "descricao LIKE ?"
      valores << "%Conexão%"
    end


    conditions << colunas
    valores.each do |valor|
    conditions << valor
    end

    @alertas                    = Alertum.where(conditions).paginate(:page => params[:page], :per_page => 30)
    @@alertas                   = Alertum.where(conditions)
    
  end

  def alerta_detalhes
    form                        = params[:form]
    if form[:monitoramento_id].eql? ""
      flash[:notice] = "Selecione o Alerta!"
      redirect_to :controller => '/relatorio', :action => 'alerta'
    end
    @monitoramento              = Monitoramento.find_by_id(form[:monitoramento_id])
    @alerta        = Alertum.find_by_monitoramento_id(form[:monitoramento_id])
  end
  
######################################################################################################################################################
# FIM                                                                  ALERTA
######################################################################################################################################################
######################################################################################################################################################
# INICIO                                                            MONITORAMENTO
######################################################################################################################################################

  def gerar_excel_monitoramento
     xls = []
     xls << ['Monitoramento;']
     xls << ["ID;", "Equip. ID;", "Equip. Descricao;", "CPU Usuario;", "CPU Sistema;", "Taxa de utilizacao de banda;", "Taxa de utilizacao de banda;", "SWAP Disp.;", "RAM Util.;", "Disco Disp.;", "IP;", "Hora;"]
    @@monitoramento.each do |monitoramento|
     xls << ["#{monitoramento.id};", 
             "#{monitoramento.equipamento_id};",
             "#{monitoramento.equipamento.try(:descricao)};",
             "#{monitoramento.uso_cpu_usuario}%;",
             "#{monitoramento.uso_cpu_sistema}%;",
             "#{monitoramento.porcentagem_utilizacao_banda}%;",
             "#{monitoramento.taxa_utilizacao_banda}Kbps;",
             "#{monitoramento.swap_disponivel.to_f/1024/1024}GB;",
             "#{monitoramento.ram_utilizada.to_f/1024/1024}GB;",
             "#{monitoramento.disco_disponivel.to_f/1024/1024}GB;",
             "#{monitoramento.ip};",
             "#{monitoramento.hora_registro.to_s.gsub('UTC','')};"
            ]
    end

    content = ''
    xls.each do |row|
#      row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/sim, " ").gsub(/ +/, " ") }
      row.map! {|col| col = col.to_s.gsub(/ +/, " ") }
      content << row.join("\t")
      content << "\n"
    end
    content

    `rm -rf "#{Rails.root}/public/excel/monitoramento_filtrar.xls`
    f = File.new("#{Rails.root}/public/excel/monitoramento_filtrar.xls", "w+")
    f << content
    f.close

    send_file "#{Rails.root}/public/excel/monitoramento_filtrar.xls"
  end

  def monitoramento_filtrar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def monitoramento_filtrar_do
    form                        = params[:form]
    colunas = ""
    valores = []
    conditions = []

    if not form[:id].eql? ""
      colunas << " AND " if not colunas.eql? ""
      colunas << "equipamento_id IN (?)"
      valores << form[:id].to_i
    end
 
    if not form[:data_inicio].eql? nil and not form[:data_fim].eql? nil
      data_inicio = Date.civil(*form[:data_inicio].sort.map(&:last).map(&:to_i))
      data_fim    = Date.civil(*form[:data_fim].sort.map(&:last).map(&:to_i))
      if not data_inicio > data_fim
        colunas << " AND " if not colunas.eql? ""
        colunas << "hora_registro >= (?) AND hora_registro <= (?)"
        valores << data_inicio.to_date
        valores << data_fim.to_date
      end
    end

    conditions << colunas
    valores.each do |valor|
    conditions << valor
    end


    @@monitoramento              = Monitoramento.where(conditions)
    @monitoramento              = Monitoramento.where(conditions).paginate(:page => params[:page], :per_page => 30)

  end

  def monitoramento_detalhes
    form                        = params[:form]
    if form[:monitoramento_id].eql? ""
      flash[:notice] = "Selecione o Monitoramento!"
      redirect_to :controller => '/relatorio', :action => 'monitoramento'
    end

    @monitoramento              = Monitoramento.find_by_id(form[:monitoramento_id])
    @alerta        = Alertum.find_by_monitoramento_id(form[:monitoramento_id])
  end


######################################################################################################################################################
# FIM                                                              MONITORAMENTO
######################################################################################################################################################

######################################################################################################################################################
# INICIO                                                            INVENTARIO
######################################################################################################################################################

  def gerar_excel_inventario
     xls = []
     xls << ['inventario;']
     xls << ["ID;", "Descricao;",  "IP;", "Cancelado;", "Monitorado;"]
    @@equipamentos.each do |equipamento|
     xls << ["#{equipamento.id};", 
             "#{equipamento.try(:descricao)};",
             "#{equipamento.ip};",
             "#{equipamento.cancelado};",
             "#{equipamento.monitorar};"
            ]
    end

    content = ''
    xls.each do |row|
#      row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/sim, " ").gsub(/ +/, " ") }
      row.map! {|col| col = col.to_s.gsub(/ +/, " ") }
      content << row.join("\t")
      content << "\n"
    end
    content

    `rm -rf "#{Rails.root}/public/excel/inventario_filtrar.xls`
    f = File.new("#{Rails.root}/public/excel/inventario_filtrar.xls", "w+")
    f << content
    f.close

    send_file "#{Rails.root}/public/excel/inventario_filtrar.xls"
  end


  def inventario_filtrar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def inventario_filtrar_do
    form                        = params[:form]
    colunas = ""
    valores = []
    conditions = []

    if not form[:id].eql? ""
      colunas << " AND " if not colunas.eql? ""
      colunas << "id IN (?)"
      valores << form[:id].to_i
    end

    if not form[:data_inicio].eql? nil and not form[:data_fim].eql? nil
      data_inicio = Date.civil(*form[:data_inicio].sort.map(&:last).map(&:to_i))
      data_fim    = Date.civil(*form[:data_fim].sort.map(&:last).map(&:to_i))

      if not data_inicio > data_fim
        colunas << " AND " if not colunas.eql? ""
        colunas << "created_at >= (?) AND created_at <= (?)"
        valores << data_inicio.to_date
        valores << data_fim.to_date
      end
    end

    unless form[:tipo].eql? ""
      colunas << " AND " if not colunas.eql? ""
      if form[:tipo].eql? "desktop"
        colunas << "tipo LIKE (?)"
        valores << form[:tipo]
      end
      if form[:tipo].eql? "router"
        colunas << "tipo LIKE (?)"
        valores << form[:tipo]
      end
      if form[:tipo].eql? "switch"
        colunas << "tipo LIKE (?)"
        valores << form[:tipo]
      end
      if form[:tipo].eql? "server"
        colunas << "tipo LIKE (?)"
        valores << form[:tipo]
      end
    end

    conditions << colunas
    valores.each do |valor|
    conditions << valor
    end


    @equipamentos              = Equipamento.where(conditions).order("id").paginate(:page => params[:page], :per_page => 30)
    @@equipamentos              = Equipamento.where(conditions).order("id")
  end

  def gerar_excel_inventario_detalhes
     xls = []
     xls << ['Inventario Detalhado;']
     xls << ['Equipamento;']
     xls << ["ID;","Descrição;","Tipo;","IP;","Mascara de Rede;","Mac address;","Garantia;","Marca;","Modelo;","Versão;","Data Backup;","Local Backup;","Data de Alteração;","Usuario de Alteração;","Especificação Tecnica;","Obeservação;","Monitorado;","Nº de Serie;","Cancelado;","Cadastrado;"]
     equipamento = @@equipamento
     xls << [
             "#{equipamento.id};",
             "#{equipamento.descricao};",
             "#{equipamento.tipo};",
             "#{equipamento.ip};",
             "#{equipamento.mascara_rede};",
             "#{equipamento.mac_address};",
             "#{equipamento.data_garantia};",
             "#{equipamento.marca};",
             "#{equipamento.modelo};",
             "#{equipamento.versao};",
             "#{equipamento.data_backup};",
             "#{equipamento.local_backup};",
             "#{equipamento.updated_at};",
             "#{equipamento.usuario_alteracao.nome};",
             "#{equipamento.especificacao_tecnica};",
             "#{equipamento.observacao};",
             "#{equipamento.monitorar};",
             "#{equipamento.numero_serie};",
             "#{equipamento.cancelado};",
             "#{equipamento.created_at};"
            ]

     xls << ['Limite do Equipamento;']
     xls << ["CPU usuario;", "CPU sistema;","SWAP Disp.;","RAM Disp;","Disco Disp.;","Upload;","Download;","Taxa de utilizacao;","Taxa de Utilizacao;"]
     xls << [
             "#{equipamento.uso_cpu_usuario}%;",
             "#{equipamento.uso_cpu_sistema}%;",
             "#{equipamento.swap_disponivel.to_f/1024/1024}Gb;",
             "#{equipamento.ram_disponivel.to_f/1024/1024}Gb;",
             "#{equipamento.disco_disponivel.to_f/1024/1024}Gb;",
             "#{equipamento.upload}Kbps;",
             "#{equipamento.download}Kbps;",
             "#{equipamento.taxa_utilizacao_banda}Kbps;",
             "#{equipamento.porcentagem_utilizacao_banda}%;"
            ]

     xls << ['Monitoramentos;']
     xls << ["ID;","CPU Usuario;","CPU Sistema;","Upload;","Download;","Taxa de utilizacao;","Taxa de Utilizacao;","SWAP Disp.;","RAM Disp.;","RAM Util.;","Disco Disp.;","Hora;"]
    @@equipamento.monitoramentos.each do |monitoramento|
     xls << [
             "#{monitoramento.id};",
             "#{monitoramento.uso_cpu_usuario}%;",
             "#{monitoramento.uso_cpu_sistema}%;",
             "#{monitoramento.upload}Kbps;",
             "#{monitoramento.download}Kbps;",
             "#{monitoramento.taxa_utilizacao_banda}Kbps;",
             "#{monitoramento.porcentagem_utilizacao_banda}%;",
             "#{monitoramento.swap_disponivel.to_f/1024/1024}Gb;",
             "#{monitoramento.ram_disponivel.to_f/1024/1024}Gb;",
             "#{monitoramento.ram_utilizada.to_f/1024/1024}Gb;",
             "#{monitoramento.disco_disponivel.to_f/1024/1024}Gb;",
             "#{monitoramento.hora_registro};"
            ]
    end

     xls << ['Alertas;']
     xls << ["ID;", "Descrição;","Hora;"]
    @@equipamento.alertas.each do |alerta|
     xls << [
             "#{alerta.id};",
             "#{alerta.descricao};",
             "#{alerta.created_at};"
            ]
    end

    content = ''
    xls.each do |row|
#      row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/sim, " ").gsub(/ +/, " ") }
      row.map! {|col| col = col.to_s.gsub(/ +/, " ") }
      content << row.join("\t")
      content << "\n"
    end
    content

    `rm -rf "#{Rails.root}/public/excel/inventario_detalhes_filtrar.xls`
    f = File.new("#{Rails.root}/public/excel/inventario_detalhes_filtrar.xls", "w+")
    f << content
    f.close

    send_file "#{Rails.root}/public/excel/inventario_detalhes_filtrar.xls"
  end


  def inventario_detalhes
    form                        = params[:form]
    if form[:equipamento_id].eql? ""
      flash[:notice] = "Selecione o Equipamento!"
      redirect_to :controller => '/relatorio', :action => 'inventario_filtrar'
    end

    @equipamento    = Equipamento.find_by_id(form[:equipamento_id]) 
    @monitoramentos = Monitoramento.where('equipamento_id IN (?)', form[:equipamento_id]).order("id")
    @alertas        = Alertum.where('equipamento_id IN (?)',form[:equipamento_id]).order("id")
    @@equipamento = @equipamento
  end

  
######################################################################################################################################################
# FIM                                                               INVENTARIO
######################################################################################################################################################

end
