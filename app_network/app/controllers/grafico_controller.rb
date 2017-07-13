class GraficoController < ApplicationController
  require 'gruff'
  def index
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end        
        form                        = params[:form]
        @equipamento                = Equipamento.find form[:equipamento_id]
        monitoramentos = Monitoramento.where("equipamento_id = #{form[:equipamento_id].to_i}").order("id DESC").limit 20
        @ultimo_monitoramento = monitoramentos.first
        i = 0
        etiquetas = {}
        cpu_usuario = []
        cpu_sistema = []
        cpu_ociosa = []
        limite_usuario_cpu = []
        limite_sistema_cpu = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            cpu_usuario << monitoramento.uso_cpu_usuario.to_i
            cpu_sistema << monitoramento.uso_cpu_sistema.to_i
            cpu_ociosa << monitoramento.porcentagem_cpu_ociosa.to_i
            limite_usuario_cpu << @equipamento.uso_cpu_usuario
            limite_sistema_cpu << @equipamento.uso_cpu_sistema
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'CPU%'
        g.labels = etiquetas
        g.data :Usuario, cpu_usuario
        g.data :Sistema, cpu_sistema
        g.data :Ociosa, cpu_ociosa
        g.data :Limite_usuario, limite_usuario_cpu
        g.data :Limite_sistema, limite_sistema_cpu

	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/cpu_porcentagem.png')

        i = 0
        etiquetas = {}
        cpu_usuario = []
        cpu_sistema = []
        cpu_ociosa = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            cpu_usuario << monitoramento.tempo_absoluto_cpu_usuario.to_f/60
            cpu_sistema << monitoramento.tempo_absoluto_cpu_sistema.to_f/60
            cpu_ociosa << monitoramento.tempo_cpu_ociosa.to_f/60
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'Tempo de uso CPU(minutos)'
        i = 0
        g.labels = etiquetas
        g.data :Usuario, cpu_usuario
        g.data :Sistema, cpu_sistema
        g.data :Ociosa, cpu_ociosa
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/cpu_tempo.png')

        i = 0
        etiquetas = {}
        swap_disponivel = []
        minimo_swap_disponivel = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            swap_disponivel << monitoramento.swap_disponivel.gsub("kB",'').to_i
            minimo_swap_disponivel << @equipamento.swap_disponivel.to_i
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'SWAP(kBs)'
        g.maximum_value = monitoramentos.last.tamanho_swap.gsub("kB",'').to_i
        g.minimum_value = 0
        g.labels = etiquetas
        g.data :Swap_Disponivel, swap_disponivel
        g.data :Minimo_swap_Disponivel, minimo_swap_disponivel
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/memoria_swap.png')

        i = 0
        etiquetas = {}
        ram_utilizada = []
        minimo_ram_disponivel = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            ram_utilizada << monitoramento.ram_utilizada.gsub("kB",'').to_i
            minimo_ram_disponivel << @equipamento.ram_disponivel.to_i
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'RAM(kBs)'
        g.maximum_value = monitoramentos.last.tamanho_ram.gsub("kB",'').to_i
        g.minimum_value = 0
        g.labels = etiquetas
        g.data :Utilizada, ram_utilizada
        g.data :minimo_RAM_disponivel, minimo_ram_disponivel
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/memoria_ram.png')

        i = 0
        etiquetas = {}
        disco_disponivel = []
        minimo_disco_disponivel = []
        disco_utilizado = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            disco_disponivel << monitoramento.disco_disponivel.gsub("kB",'').to_f/1000000
            minimo_disco_disponivel << @equipamento.disco_disponivel.to_f/1000000
            disco_utilizado << monitoramento.disco_utilizado.gsub("kB",'').to_f/1000000
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'Disco(GBs)'
        g.maximum_value = monitoramentos.last.tamanho_disco.gsub("kB",'').to_f/1000000
        g.minimum_value = 0
        g.labels = etiquetas
        g.data :Disponivel, disco_disponivel
        g.data :Utilizado, disco_utilizado
        g.data :Minimo_Disponivel, minimo_disco_disponivel
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/disco.png')


        i = 0
        etiquetas = {}
        download = []
        upload = []
        consumo_total = []
        limite_download = []
        limite_upload = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            download << monitoramento.download.gsub("Kbps",'').to_i
            upload << monitoramento.upload.gsub("Kbps",'').to_i
            consumo_total << monitoramento.taxa_utilizacao_banda.to_i
  #          limite_download << @equipamento.download.gsub("Kbps",'').to_i
  #          limite_upload << @equipamento.upload.gsub("Kbps",'').to_i
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'Uso de Banda(Kbps)'

        g.labels = etiquetas
        g.data :Download, download
        g.data :Upload, upload
        g.data :Consumo_total, consumo_total
   #     g.data :Limite_download, limite_download
   #     g.data :Limite_upload, limite_upload
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/banda.png')

        i = 0
        etiquetas = {}
        consumo_banda = []
        limite = []
        monitoramentos.sort.each do |monitoramento|
          if monitoramento.equipamento_id.eql? form[:equipamento_id].to_i
            a = i.remainder 4
            if a.eql? 0 or monitoramentos.sort.last.id.eql? monitoramento.id
              etiquetas[i] = monitoramento.hora_registro.strftime("%H:%M")
            end
            consumo_banda << monitoramento.porcentagem_utilizacao_banda.to_i
            limite << @equipamento.porcentagem_utilizacao_banda.to_i
            i = i+1
          end
        end
        
	g = Gruff::Line.new
	g.title = 'Uso de Banda(%)'
        g.maximum_value = 100
        g.minimum_value = 0

        g.labels = etiquetas
        g.data :Consumo_banda, consumo_banda
        g.data :Limite, limite
	g.write('/home/carlos/tcc/app_network/public/imagens/graficos/consumo_banda.png')


  end
end
