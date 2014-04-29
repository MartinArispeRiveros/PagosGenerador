require ('empleado')
require ('generador_cheque')
require ('cheque')
require('tarjeta_de_servicio')
require('clasificador_salario_fijo')
require ('contrato_mensual')
require ('./repositorio')

describe "Generar cheque para empleado con salario fijo" do

  #$empleado= Repositorio.new
  subject(:empleado) {Empleado.new('3343', 'Juan', 'Perez', Date.new(2012,1,1),ContratoMensual.new,"mensual",1243,ClasificadorSalarioFijo.new(300, Date.new(2012,1,1)),"fijo",true,0)}
  #gestor.initialize
  before(:each) do
    empleado.clasificador_salario = ClasificadorSalarioFijo.new(300, Date.new(2012,1,1))
  end

  context "Salario Correspondiente" do

    it "deberia generar cheque por el monto correspondiente para un empleado" do
      empleado.asignar_salario_fijo(300)
      generador = GeneradorCheque.new(Date.new(2013,1,31))
      cheque = generador.ejecutar(empleado)
      cheque.monto.should == 300
    end

    it "deberia generar cheque con salario completo para un empleado que se contrato el primero del mes" do
      empleado.asignar_salario_fijo(500)
      empleado.asignar_fecha_inicio_contrato(Date.new(2013,4,1))
      generador = GeneradorCheque.new(Date.new(2013,4,30))
      cheque = generador.ejecutar(empleado)
      cheque.monto.to_i.should == 500
    end

    it "deberia generar cheque con mitad de salario para un empleado que se contrato a mitad del mes" do
      empleado.asignar_salario_fijo(500)
      empleado.asignar_fecha_inicio_contrato(Date.new(2013,4,16))
      generador = GeneradorCheque.new(Date.new(2013,4,30))
      cheque = generador.ejecutar(empleado)
      cheque.monto.to_i.should == 250
    end
  end

  it "el cheque generado deberia corresponder al empleado y contener sus datos" do
    empleado.asignar_salario_fijo(2000)
    generador = GeneradorCheque.new(Date.new(2013,4,30))
    cheque = generador.ejecutar(empleado)
    cheque.beneficiario.should == "Juan Perez"
    cheque.ci.should == "3343"
    cheque.fecha_emision.should == (Date.new(2013,4,30))
  end

  it "si no es fin de mes no deberia generar el cheque"do
    generador=GeneradorCheque.new(Date.new(2013,4,9))
    cheque=generador.ejecutar(empleado)
    cheque.should==nil
  end

  context "Descuentos por sindicato" do

    it "si el empleado pertenece a sindicato deberia aplicarse descuento fijo" do
      empleado.asignar_salario_fijo(2000)
      empleado.asignar_descuento_sindicato(200)
      generador = GeneradorCheque.new(Date.new(2013,4,30))
      cheque = generador.ejecutar(empleado)
      cheque.monto.should == 1800
    end

    it "empleado que solicita un servicio de sindicato deberia aplicarse descuento" do
      empleado.asignar_salario_fijo(2000)
      tarjeta_servicio = TarjetaDeServicio.new(Date.new(2013,4,20),empleado.ci,100,'pulperia')
      empleado.registrar_tarjeta_de_servicio(tarjeta_servicio)
      generador = GeneradorCheque.new(Date.new(2013,4,30))
      cheque = generador.ejecutar(empleado)
      cheque.monto.should == 1900
    end

    it "empleado que solicita mas de un servicio de sindicato deberia aplicarse descuento" do
      empleado.asignar_salario_fijo(2000)
      tarjeta_servicio_1 = TarjetaDeServicio.new(Date.new(2013,4,20),empleado.ci,100,'pulperia')
      tarjeta_servicio_2 = TarjetaDeServicio.new(Date.new(2013,4,21),empleado.ci,50,'pulperia')
      tarjeta_servicio_3 = TarjetaDeServicio.new(Date.new(2013,4,22),empleado.ci,150,'pulperia')
      tarjeta_servicio_4 = TarjetaDeServicio.new(Date.new(2013,4,23),empleado.ci,30,'pulperia')
      empleado.registrar_tarjeta_de_servicio(tarjeta_servicio_1)
      empleado.registrar_tarjeta_de_servicio(tarjeta_servicio_2)
      empleado.registrar_tarjeta_de_servicio(tarjeta_servicio_3)
      empleado.registrar_tarjeta_de_servicio(tarjeta_servicio_4)
      generador = GeneradorCheque.new(Date.new(2013,4,30))
      cheque = generador.ejecutar(empleado)
      cheque.monto.should == 1670
    end
  end
end