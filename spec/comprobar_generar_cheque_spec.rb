require ('empleado')
require ('generador_cheque')
require ('cheque')
require ('date')

describe "Generar cheque para empleado sin contrato" do 

	subject(:empleado) {Empleado.new('3343', 'Juan', 'Perez', Date.new(2012,1,1),"","mensual",1243,ClasificadorSalarioFijo.new(300, Date.new(2012,1,1)),"hora",true,0)}

=begin
	it "no deberia generar cheque para un empleado sin contrato" do
		generador = GeneradorCheque.new(Date.new(2013,1,31))
		cheque = generador.ejecutar(empleado) 
		cheque.should be_nil
	end

	it "no deberia generar cheque para un empleado con contrato inexistente" do
		empleado = Empleado.crear_empleado('3343','Juan','Perez',Date.new(2012,1,1),300,'cualquiera','fijo',true,0)
		generador = GeneradorCheque.new(Date.new(2013,1,31))
		cheque = generador.ejecutar(empleado)
		cheque.should be_nil
	end
=end
end