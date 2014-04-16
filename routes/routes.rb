#require 'sinatra'
require './lib/empleado'
require './lib/clasificador_por_hora'
require './lib/clasificador_salario_fijo'
require './lib/contrato_mensual'
require './lib/contrato_quincenal'
require './empleados'
require 'date'

$empleados_gestor = Empleados.new

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
  end
  if (params[:empleado][:tipo_contrato] == 'quincenal')
    empleado.clasificador_contrato = ContratoQuincenal.new()
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
