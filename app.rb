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
require './repositorio_memoria'
require './repositorio_archivo'
require ('date')
require './lib/cheque'

$empleados_gestor = Repositorio.new
$cheques_gestor = GeneradorCheque.new(Date.today)

get '/' do
  @empleados_archivo = $empleados_gestor.obtener_empleados_archivo
  @empleados_memoria = $empleados_gestor.obtener_empleados_memoria
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
  $empleados_gestor.adicionar(empleado,$repositorio)
  @empleados_archivo = $empleados_gestor.obtener_empleados_archivo
  @empleados_memoria = $empleados_gestor.obtener_empleados_memoria
  puts @empleados_memoria
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
    @empleados_archivo = $empleados_gestor.obtener_empleados_archivo
    @empleados_memoria = $empleados_gestor.obtener_empleados_memoria
    erb :"index"
  end
end

#show
get "/show_memory/:ci" do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"show_memory"
end

#show
get "/show_archive/:ci" do
  @empleado = $empleados_gestor.mostrar_de_archivo(params[:ci])
  erb :"show_archive"
end

#delete
get '/delete/:ci' do
  @empleado = $empleados_gestor.eliminar(params[:ci],$repositorio)
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
  @empleados_memoria = $empleados_gestor.obtener_empleados_memoria
  @empleados_memoria.each do |empleado|
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
  @tarjeta = TarjetaDeTiempo.crear_tarjeta_tiempo(params[:timecard][:fecha],params[:timecard][:id_empleado],params[:timecard][:hora_ingreso],params[:timecard][:hora_salida])
  if TarjetaDeTiempo.verificar_vacio(@tarjeta)
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
  @tarjeta = TarjetaDeServicio.crear_tarjeta_servicio(params[:servicecard][:fecha],params[:servicecard][:id_empleado],params[:servicecard][:monto].to_i,params[:servicecard][:descripcion])
  @empleado.registrar_tarjeta_de_servicio(@tarjeta)
  @tarjetas = @empleado.obtener_tarjetas_de_servicio(params[:servicecard][:id_empleado])
  erb :"servicecard_index"
end

#configurations
get '/configurations' do
  erb :"configurations"
end

#save change in configurations
post '/save_configurations' do
  $repositorio = params[:tipo_almacenamiento]
  erb :"save_configurations"
end