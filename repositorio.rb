class Repositorio
  def initialize
    @empleados = [Empleado.new('1234567', 'Juan', 'Perez', Date.new(2012,2,1),ContratoMensual.new,"mensual",1234), 
  		            Empleado.new('9876543', 'Jose', 'Sanchez', Date.new(2012,3,1),ContratoQuincenal.new,"quincenal",4321),
                  Empleado.new('9876345', 'Maria','Arce', Date.new(2012,4,1),ContratoTrimestral.new,"trimestral",4323)]
  end
  
  def obtenerTodos
    @empleados
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
end
