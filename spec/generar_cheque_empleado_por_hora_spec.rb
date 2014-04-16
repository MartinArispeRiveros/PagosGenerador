require ('empleado')
require ('generador_cheque')
require ('cheque')
require('tarjeta_de_tiempo')
require('clasificador_por_hora')
require ('contrato_quincenal')
require ('./empleados')

describe "Generar cheque para empleado por hora" do
 	$empleado = Empleados.new
  subject(:empleado) { Empleado.new('3343', 'Juan', 'Perez', Date.new(2012,1,1),ContratoQuincenal.new,"quincenal",123444) }
  before (@each) {
    empleado.clasificador_salario = ClasificadorPorHora.new(50)
    empleado.asignar_pago_por_hora(50)
  }

	it "deberia generar cheque para un empleado con solo una tarjeta de tiempo" do
		tarjeta_de_tiempo = TarjetaDeTiempo.new(Date.new(2013,4,12),empleado.ci,Time.new(2013,4,12,8,0,0),Time.new(2013,4,12,20,0,0))
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
		generador = GeneradorCheque.new(Date.new(2013,4,12))
		cheque = generador.ejecutar(empleado)
		cheque.monto.should == 600
	end

	it "deberia generar cheque para un empleado con mas de una tarjeta de tiempo" do
		tarjeta_de_tiempo_1 = TarjetaDeTiempo.new(Date.new(2013,4,12),empleado.ci,Time.new(2013,4,12,8,0,0),Time.new(2013,4,12,16,0,0))
		tarjeta_de_tiempo_2 = TarjetaDeTiempo.new(Date.new(2013,4,13),empleado.ci,Time.new(2013,4,12,9,0,0),Time.new(2013,4,12,15,0,0))
		tarjeta_de_tiempo_3 = TarjetaDeTiempo.new(Date.new(2013,4,14),empleado.ci,Time.new(2013,4,12,11,0,0),Time.new(2013,4,12,20,0,0))
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo_1)
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo_2)
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo_3)
		generador = GeneradorCheque.new(Date.new(2013,4,19))
		cheque = generador.ejecutar(empleado)
		cheque.monto.should == 1150
	end

	it "deberia aplicar descuento para empleado que pertenece a sindicato" do
		empleado.asignar_descuento_sindicato(100)
		tarjeta_de_tiempo = TarjetaDeTiempo.new(Date.new(2013,4,12),empleado.ci,Time.new(2013,4,12,8,0,0),Time.new(2013,4,12,20,0,0))
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
		generador = GeneradorCheque.new(Date.new(2013,4,12))
		cheque = generador.ejecutar(empleado)
		cheque.monto.should == 500
	end

	it "el cheque no deberia generarse si no es viernes" do
		tarjeta_de_tiempo = TarjetaDeTiempo.new(Date.new(2013,4,12),empleado.ci,Time.new(2013,4,12,8,0,0),Time.new(2013,4,12,20,0,0))
		empleado.registrar_tarjeta_de_tiempo(tarjeta_de_tiempo)
		generador = GeneradorCheque.new(Date.new(2013,4,14))
		cheque = generador.ejecutar(empleado)
		cheque.should == nil
	end
end