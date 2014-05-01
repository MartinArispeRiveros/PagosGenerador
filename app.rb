require "sinatra"
require "json"
require './lib/empleado'
require './lib/clasificador_por_hora'
require './lib/clasificador_salario_fijo'
require './lib/contrato_mensual'
require './lib/contrato_quincenal'
require './lib/contrato_trimestral'
require './lib/generador_cheque'
require './lib/tarjeta_de_tiempo'
require './lib/tarjeta_de_servicio'
require './repositorio'
require ('date')
require './lib/cheque'

$empleados_gestor = Repositorio.new
$cheques_gestor = GeneradorCheque.new(Date.today)

get '/' do
  @empleados = $empleados_gestor.obtener_empleados
  erb :"index"
end

get '/new' do
  erb :new
end

#create 
post '/crear_empleado' do 
  empleado = Empleado.crear_empleado(params[:empleado][:ci],
                                     params[:empleado][:nombre], 
                                     params[:empleado][:apellido], 
                                     Date.today, 
                                     params[:empleado][:salario].to_f, 
                                     params[:empleado][:tipo_contrato], 
                                     params[:empleado][:tipo_salario], 
                                     params[:empleado][:pertenece_sindicato], 
                                     params[:empleado][:descuento_sindicato].to_f)

  if params[:empleado][:tipo_almacenamiento]
    $empleados_gestor.adicionar_archivo(empleado)
  else
    $empleados_gestor.adicionar(empleado)
  end

  @empleados = $empleados_gestor.obtener_empleados
  erb :"index"
end

get '/edit/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"edit"
end

#edit
post '/actualizar_empleado/:ci' do
  
  empleado = $empleados_gestor.buscar_por_ci(params[:empleado][:ci])
  empleado_modificado = empleado.modificar_empleado(params[:empleado][:ci], 
                                                    params[:empleado][:nombre], 
                                                    params[:empleado][:apellido],
                                                    params[:empleado][:salario].to_f,
                                                    params[:empleado][:tipo_contrato],
                                                    params[:empleado][:tipo_salario],
                                                    params[:empleado][:pertenece_sindicato],
                                                    params[:empleado][:descuento_sindicato])

  if ($empleados_gestor.actualizar(empleado_modificado))  
    @empleados = $empleados_gestor.obtener_empleados
    erb :"index"
  end
end

#show
get "/show/:ci" do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"show"
end

#delete
get '/delete/:ci' do
  @empleado = $empleados_gestor.eliminar(params[:ci])
  erb :"delete"
end

#create check
get '/add_check/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  @cheque = $cheques_gestor.ejecutar(@empleado)
  if @cheque != nil
    $empleados_gestor.adicionar_cheque(@cheque)
    erb :"add_check"
  else
    erb :"not_check"  
  end
end

get '/checks' do
  @empleados = $empleados_gestor.obtener_empleados
  @empleados.each do |empleado|
    if empleado.check == false
      cheque = $cheques_gestor.ejecutar(empleado)
      if cheque != nil
        $empleados_gestor.adicionar_cheque(cheque)
        empleado.check=true
        $empleados_gestor.actualizar(empleado)
      end
    end
  end
  
  if $empleados_gestor.obtener_cheques != []
    @cheques = $empleados_gestor.obtener_cheques
    erb :"checks"    
  else
    erb :"not_checks"
  end
end

get '/timecard/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"timecard"
end

get '/timecard_index/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  @tarjetas = @empleado.tarjetas_de_tiempo(params[:ci])
  erb :"timecard_index"
end

get '/servicecard/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"servicecard"
end

get '/servicecard_index/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  @tarjetas = @empleado.obtener_tarjetas_de_servicio(params[:ci])
  erb :"servicecard_index"
end

#create timecard
post '/create_timecard/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:timecard][:id_empleado])
  @tarjeta = TarjetaDeTiempo.new(params[:timecard][:fecha],params[:timecard][:id_empleado],params[:timecard][:hora_ingreso],params[:timecard][:hora_salida])
  if @tarjeta.fecha != "" || @tarjeta.hora_ingreso != "" || @tarjeta.hora_salida != ""
    @empleado.registrar_tarjeta_de_tiempo(@tarjeta)
    @tarjetas = @empleado.tarjetas_de_tiempo(params[:timecard][:id_empleado])
    erb :"timecard_index" 
  else
   erb :"timecard" 
  end
end

#create servicecard
post '/create_servicecard/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:servicecard][:id_empleado])
  @tarjeta = TarjetaDeServicio.new(params[:servicecard][:fecha],params[:servicecard][:id_empleado],params[:servicecard][:monto].to_i,params[:servicecard][:descripcion])
  
    @empleado.registrar_tarjeta_de_servicio(@tarjeta)
    @tarjetas = @empleado.obtener_tarjetas_de_servicio(params[:servicecard][:id_empleado])
    erb :"servicecard_index"
end

get '/add' do
  empl_params = Hash.new
  empl_params[:ci] = '123'
  empl_params[:nombre] = 'Juan'
  empl_params[:apellido] = 'Perez'
  empl_params[:fecha_contrato] = Date.new(2012,2,1)
  empl_params[:tipo_contrato] = '1'
  $empleados_gestor.adicionar(empl_params)
  @empleados = $empleados_gestor.obtener_empleados
  erb :"index"
end

get '/save_archive/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  @empleado.en_archivo = true
  archivo = $empleados_gestor.to_json(@empleado)
  lista_empleados = File.open('archive.json', 'a')
  lista_empleados << archivo
  lista_empleados << "\n"
  lista_empleados.close
  erb :"save_archive"
end

get '/index_archive' do
  @archivo = File.open('archive.json', 'r')
  @lista = []
  while empleado = @archivo.gets
    @lista.push(empleado)
  end
  erb :"index_archive"
end