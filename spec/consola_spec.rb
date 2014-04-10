require('consola_test')
require ('cheque')

describe "Consola" do
  it "Imprime mensaje si no es ultimo dia del mes" do
    consola = ConsolaTest.new
    cheque = Cheque.new('3343', 'Juan Perez', Date.new(2013,12,12),300)
    consola.imprimir_cheque(cheque)
    consola.buffer_pantalla.should == "No se pudo imprimir el cheque, porque aun no es fin de mes"
  end

  it "Imprime cheque si es ultimo dia del mes, para un empleado" do
    consola = ConsolaTest.new
    cheque = Cheque.new('123456', 'Pedro Mamani', Date.new(2013,12,31), 2000)
    consola.imprimir_cheque(cheque)
    consola.buffer_pantalla.should == "Nombre completo: Pedro Mamani\nCi: 123456\nMonto a cobrar: 2000$\nFecha emision:"+Date.today.to_s+"\nFirma:___________________________"
  end
end
