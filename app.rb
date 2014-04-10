require "sinatra"
require './lib/empleado'
require './lib/clasificador_por_hora'
require './lib/clasificador_salario_fijo'
require './lib/contrato_mensual'
require './lib/contrato_quincenal'
require './lib/contrato_trimestral'
require './repositorio'
require ('date')
require './cheques'
require './lib/cheque'
#require './lib/generador_cheques'


$empleados_gestor = Repositorio.new
#empleado.salario = 0
#empleado.descuento_fijo_sindicato = 0
$cheques = Cheques.new


get '/' do
  @empleados = $empleados_gestor.obtenerTodos
  erb :"index"
end

get '/new' do
  erb :new
end

post '/crear_empleado' do 

  empleado = Empleado.crear_empleado(params[:empleado][:ci],
                                     params[:empleado][:nombre],
                                     params[:empleado][:apellido],
                                     params[:empleado][:fecha],
                                     params[:empleado][:salario],
                                     params[:empleado][:tipo_contrato],
                                     params[:empleado][:tipo_salario])
  $empleados_gestor.adicionar(empleado)
  @empleados = $empleados_gestor.obtenerTodos
  erb :"index"
end

get '/asignar_salario/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"salario"
end

post '/asignar_salario/:ci' do
   empleado = $empleados_gestor.buscar_por_ci(params[:ci])
   @empleados = $empleados_gestor.obtenerTodos
   erb :"index"
end

get '/edit/:ci' do
  @empleado = $empleados_gestor.buscar_por_ci(params[:ci])
  erb :"edit"
end

post '/actualizar_empleado/:ci' do
  empleado = $empleados_gestor.buscar_por_ci(params[:empleado][:ci])
  empleado.ci = params[:empleado][:ci]
  empleado.nombre = params[:empleado][:nombre]
  empleado.apellido = params[:empleado][:apellido]
  
  if (params[:empleado][:tipo_contrato] == 'mensual')
    empleado.clasificador_contrato = ContratoMensual.new()
    empleado.contrato = "mensual"
  end
  if (params[:empleado][:tipo_contrato] == 'quincenal')
    empleado.clasificador_contrato = ContratoQuincenal.new()
    empleado.contrato = "quincenal"
  end

  if (params[:empleado][:tipo_contrato] == 'trimestral')
    empleado.clasificador_contrato = ContratoTrimestral.new()
    empleado.contrato = "trimestral"
  end
  
  if (params[:empleado][:tipo_salario] == 'fijo')
    empleado.clasificador_salario = ClasificadorSalarioFijo.new(params[:empleado][:fecha], params[:empleado][:salario])
  end
  if (params[:empleado][:tipo_hora] == 'hora')
    empleado.clasificador_salario = ClasificadorPorHora.new(params[:empleado][:salario])
  end

  
  if ($empleados_gestor.actualizar(empleado))  
    @empleados = $empleados_gestor.obtenerTodos
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

#genarate check
get "/check_index" do
  @empleados = $empleados_gestor.obtenerTodos
  @cheques = $cheques.generar_cheques_para_lista(@empleados)
  erb :"check_index"
end

get '/add' do
  empl_params = Hash.new
  empl_params[:ci] = '123'
  empl_params[:nombre] = 'Juan'
  empl_params[:apellido] = 'Perez'
  empl_params[:fecha_contrato] = Date.new(2012,2,1)
  empl_params[:tipo_contrato] = '1'
  $empleados_gestor.adicionar(empl_params)
  @empleados = $empleados_gestor.obtenerTodos
  erb :"index"
end

