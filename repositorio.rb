class Repositorio
  def initialize
    @empleados = [Empleado.new('1234567', 'Juan', 'Perez', Date.new(2013,2,1),ContratoMensual.new,"mensual",1000,ClasificadorSalarioFijo.new(1000,Date.today),"fijo",true), 
  		            Empleado.new('9876543', 'Jose', 'Sanchez', Date.new(2013,1,1),ContratoQuincenal.new,"quincenal",100,ClasificadorPorHora.new(100),"hora",true),
                  Empleado.new('9876345', 'Maria','Arce', Date.new(2013,1,1),ContratoTrimestral.new,"trimestral",2000,ClasificadorSalarioFijo.new(2000,Date.today),"fijo",false)]
    @cheques = []
  end
  
  def obtener_empleados
    @empleados
  end

  def obtener_cheques
    @cheques
  end
  
  def adicionar(empleado)
    @empleados.push(empleado)
  end
  
  def buscar_por_ci(ci)
    @empleados.each do |empleado|
      if (empleado.ci==ci)
        return empleado
      end
    end
  end
  
  def actualizar(empleado)
    @empleados = @empleados.map{|emp| if (emp.ci == empleado.ci)
                                        empleado
                                      else
                                        emp
                                      end}
  end

  def mostrar(ci)
    @empleados.each do |empleado|
      if (empleado.ci == ci)
        @empleado = empleado
      end
    end
  end

  def eliminar(ci)  
    empleado = buscar_por_ci(ci)
    @empleados.delete(empleado)
  end  

  def adicionar_cheque(cheque)    
        @cheques.push(cheque)    
  end
end
